<%@ Application Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Threading" %>

<script RunAt="server">

    public System.Threading.Thread schedulerThread = null;

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        Application["user_sessions"] = 0;

        SchedulerConfiguration config = new SchedulerConfiguration(1000 * 480);
        config.Jobs.Add(new SampleJob());
        Scheduler scheduler = new Scheduler(config);
        System.Threading.ThreadStart myThreadStart = new System.Threading.ThreadStart(scheduler.Start);
        System.Threading.Thread schedulerThread = new System.Threading.Thread(myThreadStart);
        schedulerThread.Start();

        try
        {
            //初始化实体类，以加快后续的操作速度
            ShareClass.InitialNhibernateEntryClass();
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile(err.Message.ToString());
        }
    }

    void Application_End(object sender, EventArgs e)
    {
        if (null != schedulerThread)
        {
            schedulerThread.Abort();
        }

        try
        {
            //初始化实体类，以加快后续的操作速度
            ShareClass.InitialNhibernateEntryClass();
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile(err.Message.ToString());
        }
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs
        try
        {
            string error;
            Exception objErr = Server.GetLastError().GetBaseException();
            error = "URL: " + Request.Url.ToString() + "\n";
            error += "Message " + objErr.Message + "\n";
            error += objErr.StackTrace + "\n";

            if (error.IndexOf("System.Web.HttpApplication.IExecutionStep.Execute()") < 0)
            {
                //LogClass.WriteLogFile(error);
            }
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile(err.Message.ToString());
        }
    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started
        Application.Lock();
        Application["user_sessions"] = (int)Application["user_sessions"] + 1;
        Application.UnLock();
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
        Application.Lock();
        Application["user_sessions"] = (int)Application["user_sessions"] - 1;
        Application.UnLock();
    }

    void Application_BeginRequest(Object sender, EventArgs e)
    {
        string strLangCode = System.Configuration.ConfigurationManager.AppSettings["DefaultLang"];

        try
        {
            if (Request.Cookies["LangCode"] != null)
            {
                string cultureCode = Request.Cookies["LangCode"].Value.ToString();

                // 只设置界面文化为用户选择的文化
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(cultureCode);

                //// 关键修改：数据处理使用固定文化（避免佛教历等问题）
                //// 使用英文（美国）文化，确保公历和标准时间格式
                //System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");

                // 或者使用不变文化（更推荐，完全不受区域设置影响）
                // System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;

                if ("th,km,lo,my".IndexOf(cultureCode) == -1)
                {
                    //如果需要支持多种公历文化，可以根据语言代码映射
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(cultureCode);
                }
                else
                {
                    //如果需要支持多种公历文化，可以根据语言代码映射
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
                }
            }
            else
            {
                // 只设置界面文化为用户选择的文化
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(strLangCode);
                if ("th,km,lo,my".IndexOf(strLangCode) == -1)
                {
                    //如果需要支持多种公历文化，可以根据语言代码映射
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(strLangCode);
                }
                else
                {
                    //如果需要支持多种公历文化，可以根据语言代码映射
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
                }
            }
        }
        catch (Exception err)
        {
            // 出错时也确保使用安全的文化设置
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(strLangCode);
            if ("th,km,lo,my".IndexOf(strLangCode) == -1)
            {
                //如果需要支持多种公历文化，可以根据语言代码映射
                System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(strLangCode);
            }
            else
            {
                //如果需要支持多种公历文化，可以根据语言代码映射
                System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
            }
        }
    }


    public class SchedulerConfiguration
    {
        //时间间隔
        private int sleepInterval;
        //任务列表
        private ArrayList jobs = new ArrayList();

        public int SleepInterval { get { return sleepInterval; } }
        public ArrayList Jobs { get { return jobs; } }

        //调度配置类的构造函数
        public SchedulerConfiguration(int newSleepInterval)
        {
            sleepInterval = newSleepInterval;
        }
    }

    public interface ISchedulerJob
    {
        void Execute();
    }

    public class SampleJob : ISchedulerJob
    {
        public void Execute()
        {
            //执行定时器页
            ShareClass.ExecuteTakeTopTimer();
        }
    }

    public class Scheduler
    {
        private SchedulerConfiguration configuration = null;

        public Scheduler(SchedulerConfiguration config)
        {
            configuration = config;
        }

        public void Start()
        {
            while (true)
            {
                //执行每一个任务
                foreach (ISchedulerJob job in configuration.Jobs)
                {
                    ThreadStart myThreadDelegate = new ThreadStart(job.Execute);
                    Thread myThread = new Thread(myThreadDelegate);
                    myThread.Start();
                    Thread.Sleep(configuration.SleepInterval);
                }
            }
        }
    }


</script>

