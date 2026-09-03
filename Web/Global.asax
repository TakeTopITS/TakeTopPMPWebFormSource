<%@ Application Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Threading" %>

<script RunAt="server">

    public System.Threading.Thread schedulerThread = null;
    private Scheduler scheduler = null;

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        Application["user_sessions"] = 0;

        SchedulerConfiguration config = new SchedulerConfiguration(1000 * 480);
        config.Jobs.Add(new SampleJob());
        this.scheduler = new Scheduler(config);
        System.Threading.ThreadStart myThreadStart = new System.Threading.ThreadStart(this.scheduler.Start);
        this.schedulerThread = new System.Threading.Thread(myThreadStart);
        this.schedulerThread.IsBackground = true;
        this.schedulerThread.Start();

        try
        {
            //��ʼ��ʵ���࣬�Լӿ�����Ĳ����ٶ�
            ShareClass.InitialNhibernateEntryClass();
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile(err.Message.ToString());
        }
    }

    void Application_End(object sender, EventArgs e)
    {
        try
        {
            // 停止后台调度器线程（先置停止标志，避免中断时访问已卸载的 AppDomain）
            if (null != this.scheduler)
            {
                this.scheduler.Stop();
            }
        }
        catch (Exception err)
        {
            //LogClass.WriteLogFile(err.Message.ToString());
        }

        if (null != schedulerThread)
        {
            schedulerThread.Abort();
        }

        try
        {
            //��ʼ��ʵ���࣬�Լӿ�����Ĳ����ٶ�
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

                // ֻ���ý����Ļ�Ϊ�û�ѡ����Ļ�
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(cultureCode);

                //// �ؼ��޸ģ����ݴ���ʹ�ù̶��Ļ����������������⣩
                //// ʹ��Ӣ�ģ��������Ļ���ȷ�������ͱ�׼ʱ���ʽ
                //System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");

                // ����ʹ�ò����Ļ������Ƽ�����ȫ������������Ӱ�죩
                // System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;

                if ("th,km,lo,my".IndexOf(cultureCode) == -1)
                {
                    //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(cultureCode);
                }
                else
                {
                    //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
                }
            }
            else
            {
                // ֻ���ý����Ļ�Ϊ�û�ѡ����Ļ�
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(strLangCode);
                if ("th,km,lo,my".IndexOf(strLangCode) == -1)
                {
                    //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(strLangCode);
                }
                else
                {
                    //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                    System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
                }
            }
        }
        catch (Exception err)
        {
            // ����ʱҲȷ��ʹ�ð�ȫ���Ļ�����
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(strLangCode);
            if ("th,km,lo,my".IndexOf(strLangCode) == -1)
            {
                //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(strLangCode);
            }
            else
            {
                //�����Ҫ֧�ֶ��ֹ����Ļ������Ը������Դ���ӳ��
                System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en");
            }
        }
    }


    public class SchedulerConfiguration
    {
        //ʱ����
        private int sleepInterval;
        //�����б�
        private ArrayList jobs = new ArrayList();

        public int SleepInterval { get { return sleepInterval; } }
        public ArrayList Jobs { get { return jobs; } }

        //����������Ĺ��캯��
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
            //ִ�ж�ʱ��ҳ
            ShareClass.ExecuteTakeTopTimer();
        }
    }

    public class Scheduler
    {
        private SchedulerConfiguration configuration = null;
        private volatile bool isRunning = false;

        public Scheduler(SchedulerConfiguration config)
        {
            configuration = config;
        }

        public void Start()
        {
            isRunning = true;
            while (isRunning)
            {
                //ִ��ÿһ������
                foreach (ISchedulerJob job in configuration.Jobs)
                {
                    if (!isRunning) break;
                    ThreadStart myThreadDelegate = new ThreadStart(job.Execute);
                    Thread myThread = new Thread(myThreadDelegate);
                    myThread.IsBackground = true;
                    myThread.Start();
                    Thread.Sleep(configuration.SleepInterval);
                }
            }
        }

        public void Stop()
        {
            isRunning = false;
        }
    }


</script>

