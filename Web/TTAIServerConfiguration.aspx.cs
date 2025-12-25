using com.sun.org.apache.xerces.@internal.xs;

using Newtonsoft.Json;

using System;
using System.Data;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TTAIServerConfiguration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUserCode, strUserName;
      
        strUserCode = Session["UserCode"].ToString();
        strUserName = Session["UserName"].ToString();

        if (!IsPostBack)
        {
            LoadCurrentConfiguration();
            UpdateStatusDisplay();
        }
    }

    // Load current configuration from database
    private void LoadCurrentConfiguration()
    {
        try
        {
            string strHQL = "SELECT AIType, URL, AIKey, Model, InUse FROM T_AIInterface WHERE InUse = 'YES'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];

                string aiType = row["AIType"].ToString().Trim();
                string url = row["URL"].ToString().Trim();
                string aiKey = row["AIKey"].ToString().Trim();
                string model = row["Model"].ToString().Trim();

                // Set UI controls
                if (aiType == "Local")
                {
                    rbLocal.Checked = true;
                }
                else
                {
                    rbExternal.Checked = true;
                }

                txtApiUrl.Text = url;
                txtApiKey.Text = aiKey;
                txtModel.Text = model;

                // Update current info display
                UpdateCurrentInfoDisplay(aiType, url, model);
            }
            else
            {
                // Set defaults
                rbLocal.Checked = true;
                txtApiUrl.Text = "http://localhost:11434/v1/chat/completions";
                txtModel.Text = "deepseek-r1:1.5b";
                UpdateCurrentInfoDisplay(
                    LanguageHandle.GetWord("AINotConfigured"),
                    LanguageHandle.GetWord("AINotConfigured"),
                    LanguageHandle.GetWord("AINotConfigured"));
            }

            // Update AI Key row visibility
            UpdateAIKeyVisibility();
        }
        catch (Exception ex)
        {
            ShowStatus(LanguageHandle.GetWord("AIErrorLoadingConfig") + ex.Message, "error");
        }
    }

    // AI Type changed event
    protected void AIType_Changed(object sender, EventArgs e)
    {
        UpdateAIKeyVisibility();

        // Set default values based on AI type
        if (rbLocal.Checked)
        {
            if (string.IsNullOrEmpty(txtApiUrl.Text.Trim()))
            {
                txtApiUrl.Text = "http://localhost:11434/v1/chat/completions";
            }
            if (string.IsNullOrEmpty(txtModel.Text.Trim()))
            {
                txtModel.Text = "deepseek-r1:1.5b";
            }
        }
        else if (rbExternal.Checked)
        {
            if (string.IsNullOrEmpty(txtApiUrl.Text.Trim()))
            {
                txtApiUrl.Text = "https://api.openai.com/v1/chat/completions";
            }
            if (string.IsNullOrEmpty(txtModel.Text.Trim()))
            {
                txtModel.Text = "gpt-3.5-turbo";
            }
        }
    }

    // Update AI Key row visibility
    private void UpdateAIKeyVisibility()
    {
        rowApiKey.Visible = rbExternal.Checked;
    }

    // Test connection button click
    protected void btnTestConnection_Click(object sender, EventArgs e)
    {
        if (!ValidateInput())
        {
            return;
        }

        try
        {
            string aiType = rbLocal.Checked ? "Local" : "Outer";
            string apiUrl = txtApiUrl.Text.Trim();
            string apiKey = txtApiKey.Text.Trim();
            string model = txtModel.Text.Trim();

            bool isConnected = false;
            string testResult = "";

            if (aiType == "Local")
            {
                isConnected = TestOllamaConnectionSync(apiUrl, model);
                testResult = isConnected ?
                    LanguageHandle.GetWord("AILocalServerReachable") :
                    LanguageHandle.GetWord("AICannotConnectLocal");
            }
            else
            {
                isConnected = TestExternalAIConnectionSync(apiUrl, apiKey, model);
                testResult = isConnected ?
                    LanguageHandle.GetWord("AIExternalServerReachable") :
                    LanguageHandle.GetWord("AICannotConnectExternal");
            }

            ShowStatus(testResult, isConnected ? "success" : "error");

            // Update current info
            lblCurrentStatus.Text = isConnected ?
                LanguageHandle.GetWord("AIConnected") :
                LanguageHandle.GetWord("AINotConnected");
            lblLastTestTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");

            if (isConnected)
            {
                UpdateCurrentInfoDisplay(aiType, apiUrl, model);
            }
        }
        catch (Exception ex)
        {
            ShowStatus(LanguageHandle.GetWord("AIConnectionTestFailed") + ex.Message, "error");
            lblCurrentStatus.Text = LanguageHandle.GetWord("AITestFailed");
            lblLastTestTime.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }

    // Test Ollama connection
    private bool TestOllamaConnectionSync(string apiUrl, string model)
    {
        try
        {
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(15);

                var requestBody = new
                {
                    model = model,
                    messages = new[]
                    {
                        new { role = "user", content = "test" }
                    },
                    max_tokens = 1,
                    stream = false
                };

                string jsonContent = JsonConvert.SerializeObject(requestBody);
                HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                // For local Ollama, even error responses mean server is reachable
                return response != null;
            }
        }
        catch
        {
            return false;
        }
    }

    // Test external AI connection
    private bool TestExternalAIConnectionSync(string apiUrl, string apiKey, string model)
    {
        try
        {
            using (HttpClient client = new HttpClient())
            {
                client.Timeout = TimeSpan.FromSeconds(15);

                if (!string.IsNullOrEmpty(apiKey))
                {
                    client.DefaultRequestHeaders.Add("Authorization", $"Bearer {apiKey}");
                }

                var requestBody = new
                {
                    model = model,
                    messages = new[]
                    {
                        new { role = "user", content = "test" }
                    },
                    max_tokens = 1,
                    stream = false
                };

                string jsonContent = JsonConvert.SerializeObject(requestBody);
                HttpContent httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                HttpResponseMessage response = client.PostAsync(apiUrl, httpContent).Result;

                // For external AI, we need a successful response
                return response.IsSuccessStatusCode;
            }
        }
        catch
        {
            return false;
        }
    }

    // Save configuration button click
    protected void btnSaveConfiguration_Click(object sender, EventArgs e)
    {
        if (!ValidateInput())
        {
            return;
        }

        try
        {
            string aiType = rbLocal.Checked ? "Local" : "Outer";
            string apiUrl = EscapeSql(txtApiUrl.Text.Trim());
            string apiKey = EscapeSql(txtApiKey.Text.Trim());
            string model = EscapeSql(txtModel.Text.Trim());

            // Check if configuration exists
            string checkSql = "SELECT COUNT(*) FROM T_AIInterface WHERE InUse = 'YES'";
            DataSet ds = ShareClass.GetDataSetFromSql(checkSql, "TempTable");
            int count = 0;
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                count = Convert.ToInt32(ds.Tables[0].Rows[0][0]);
            }

            if (count > 0)
            {
                // Update existing configuration
                string updateSql = string.Format(@"
                    UPDATE T_AIInterface SET 
                        AIType = '{0}', 
                        URL = '{1}', 
                        AIKey = '{2}', 
                        Model = '{3}',
                        InUse = 'YES'
                    WHERE InUse = 'YES'",
                    aiType, apiUrl, apiKey, model);

                ShareClass.RunSqlCommand(updateSql);
            }
            else
            {
                // Insert new configuration
                string insertSql = string.Format(@"
                    INSERT INTO T_AIInterface 
                    (AIType, URL, AIKey, Model, InUse) 
                    VALUES ('{0}', '{1}', '{2}', '{3}', 'YES')",
                    aiType, apiUrl, apiKey, model);

                ShareClass.RunSqlCommand(insertSql);
            }

            ShowStatus(LanguageHandle.GetWord("AIConfigSavedSuccess"), "success");

            // Update current info display
            UpdateCurrentInfoDisplay(aiType, apiUrl, model);
            lblCurrentStatus.Text = LanguageHandle.GetWord("AINotTested");
            lblLastTestTime.Text = LanguageHandle.GetWord("AINeverTested");
        }
        catch (Exception ex)
        {
            ShowStatus(LanguageHandle.GetWord("AIErrorSavingConfig") + ex.Message, "error");
        }
    }

    // Load current configuration button click
    protected void btnLoadConfiguration_Click(object sender, EventArgs e)
    {
        LoadCurrentConfiguration();
        ShowStatus(LanguageHandle.GetWord("AICurrentConfigLoaded"), "success");
    }

    // Reset to default button click
    protected void btnReset_Click(object sender, EventArgs e)
    {
        // Set local AI defaults
        rbLocal.Checked = true;
        rbExternal.Checked = false;
        txtApiUrl.Text = "http://localhost:11434/v1/chat/completions";
        txtApiKey.Text = "";
        txtModel.Text = "deepseek-r1:1.5b";

        UpdateAIKeyVisibility();
        ShowStatus(LanguageHandle.GetWord("AIResetToDefault"), "success");
        UpdateCurrentInfoDisplay(
            LanguageHandle.GetWord("AILocalAI"),
            "http://localhost:11434/v1/chat/completions",
            "deepseek-r1:1.5b");
    }

    // Validate input
    private bool ValidateInput()
    {
        if (string.IsNullOrEmpty(txtApiUrl.Text.Trim()))
        {
            ShowStatus(LanguageHandle.GetWord("AIEnterAPIURL"), "error");
            txtApiUrl.Focus();
            return false;
        }

        if (string.IsNullOrEmpty(txtModel.Text.Trim()))
        {
            ShowStatus(LanguageHandle.GetWord("AIEnterModelName"), "error");
            txtModel.Focus();
            return false;
        }

        if (rbExternal.Checked && string.IsNullOrEmpty(txtApiKey.Text.Trim()))
        {
            ShowStatus(LanguageHandle.GetWord("AIAPIKeyRequired"), "error");
            txtApiKey.Focus();
            return false;
        }

        return true;
    }

    // Show status message
    private void ShowStatus(string message, string type)
    {
        ScriptManager.RegisterStartupScript(this.UpdatePanel1, this.GetType(), "click",
            "showAlertAtMouse('" + message.Replace("'", "\\'") + "')", true);
    }

    // Update current info display
    private void UpdateCurrentInfoDisplay(string serverType, string serverUrl, string model)
    {
        lblCurrentServerType.Text = serverType;
        lblCurrentServerUrl.Text = serverUrl;
        lblCurrentModel.Text = model;
    }

    // Update status display based on configuration
    private void UpdateStatusDisplay()
    {
        try
        {
            string strHQL = "SELECT AIType, URL, Model FROM T_AIInterface WHERE InUse = 'YES'";
            DataSet ds = ShareClass.GetDataSetFromSql(strHQL, "T_AIInterface");

            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow row = ds.Tables[0].Rows[0];
                string aiType = row["AIType"].ToString().Trim();
                string url = row["URL"].ToString().Trim();
                string model = row["Model"].ToString().Trim();

                if (aiType == "Local")
                {
                    ShowStatus(LanguageHandle.GetWord("AILocalConfigActive"), "success");
                }
                else
                {
                    ShowStatus(LanguageHandle.GetWord("AIExternalConfigActive"), "success");
                }

                UpdateCurrentInfoDisplay(aiType, url, model);
            }
            else
            {
                ShowStatus(LanguageHandle.GetWord("AINoAIConfigFound"), "warning");
                UpdateCurrentInfoDisplay(
                    LanguageHandle.GetWord("AINotConfigured"),
                    LanguageHandle.GetWord("AINotConfigured"),
                    LanguageHandle.GetWord("AINotConfigured"));
            }
        }
        catch (Exception ex)
        {
            ShowStatus(LanguageHandle.GetWord("AIErrorLoadingConfig") + ex.Message, "error");
        }
    }

    // Escape SQL string
    private string EscapeSql(string input)
    {
        if (string.IsNullOrEmpty(input))
            return string.Empty;

        return input.Replace("'", "''");
    }
}