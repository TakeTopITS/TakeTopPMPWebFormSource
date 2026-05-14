using NHibernate;

using Npgsql;//using System.Data.SqlClient;

using System;
using System.Collections;
using System.Configuration;
using System.IO;
using System.Security;
using System.Web;

namespace ProjectMgt.DAL
{
    public class EntityControl
    {
        private static EntityControl entity;

        private string _AssemblyName;

        private static readonly object padlock = new object();

        public static EntityControl CreateEntityControl(string AssemblyName)
        {
            if (entity == null)
            {
                lock (padlock)
                {
                    if (entity == null)
                    {
                        entity = new EntityControl();

                        entity._AssemblyName = AssemblyName;
                    }
                }
            }

            return entity;
        }

        public void AddEntity(Object entity)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Save(entity);

                transaction.Commit();

                InsertUserOperateLog("Add Record " + entity.ToString());
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                WriteLogFile("AddEntity Error: " + ex.Message + "\n" + ex.StackTrace);

                throw;
            }
            finally
            {
                session.Close();
            }
        }

        public void UpdateEntity(Object entity, Object key)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Update(entity, key);

                transaction.Commit();

                InsertUserOperateLog("Update Record " + entity.ToString() + "," + " The Key is " + key.ToString());
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                WriteLogFile("UpdateEntity Error: " + ex.Message + "\n" + ex.StackTrace);

                throw;
            }
            finally
            {
                session.Close();
            }
        }

        public void DeleteEntity(object entity)
        {
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            ITransaction transaction = session.BeginTransaction();

            try
            {
                session.Delete(entity);

                transaction.Commit();

                InsertUserOperateLog("Delete Record " + entity.ToString());
            }
            catch (Exception ex)
            {
                transaction.Rollback();

                WriteLogFile("DeleteEntity Error: " + ex.Message + "\n" + ex.StackTrace);

                throw;
            }
            finally
            {
                session.Close();
            }
        }


        public IList GetEntities(string strHQL)
        {
            IList lst;
            ISession session = SessionFactory.OpenSession(_AssemblyName);

            try
            {
                // ������
                string safeHQL = ApplyHQLSecurity(strHQL);

                lst = session.CreateQuery(safeHQL).List();
            }
            catch (NHibernate.Hql.Ast.ANTLR.QuerySyntaxException ex)
            {
                // ���ת�嵼���﷨���󣬼�¼���׳���ȫ�쳣
                WriteLogFile("Error page: " + "\n" + ex.Message.ToString() + "\n" + ex.StackTrace + ",\n HQL syntax security validation failed" + ex.Message.ToString() + ",Sql: \n" + strHQL);
                throw new SecurityException("HQL syntax security validation failed", ex);

            }
            finally
            {
                session.Close();
            }

            InsertUserOperateLog(strHQL);
            return lst;
        }

        // �ۺϰ�ȫ����
        private string ApplyHQLSecurity(string hql)
        {
            if (string.IsNullOrEmpty(hql))
                return hql;

            // 1. ������֤
            if (hql.Length > 10000) // ��ֹ������ѯ
            {
                WriteLogFile("ErrorMsg =" + "HQL Statement Is Too Long,Hql:" + hql);
                throw new SecurityException("HQL Statement Is Too Long");
            }

            // 2. Σ�ղ������
            ValidateDangerousOperations(hql);

            // 3. �ַ���ת��
            string safeHql = EscapeStringLiterals(hql);

            // 4. ע������
            safeHql = RemoveSqlComments(safeHql);

            return safeHql;
        }

        // ת���ַ�������
        private string EscapeStringLiterals(string hql)
        {
            return System.Text.RegularExpressions.Regex.Replace(hql,
                @"'([^']*)'",
                match =>
                {
                    string innerValue = match.Groups[1].Value;
                    // ���ת�����
                    string escaped = innerValue
                        .Replace("'", "''")  // ת�嵥����
                        .Replace(";", "")    // �Ƴ��ֺ�
                        .Replace("--", "")   // �Ƴ�SQLע��
                        .Replace("/*", "")   // �Ƴ�����ע�Ϳ�ʼ
                        .Replace("*/", "");  // �Ƴ�����ע�ͽ���
                    return $"'{escaped}'";
                });
        }

        // �Ƴ�SQLע��
        private string RemoveSqlComments(string hql)
        {
            string noComments = System.Text.RegularExpressions.Regex.Replace(hql, @"--.*$", "",
                System.Text.RegularExpressions.RegexOptions.Multiline);
            noComments = System.Text.RegularExpressions.Regex.Replace(noComments, @"/\*.*?\*/", "",
                System.Text.RegularExpressions.RegexOptions.Singleline);
            return noComments;
        }

        // ��֤Σ�ղ���
        private void ValidateDangerousOperations(string hql)
        {
            string upperHql = hql.ToUpper();

            var dangerousKeywords = new[]
            {
        "DROP ", "DELETE ", "UPDATE ", "INSERT ", "EXEC ", "EXECUTE ",
        "TRUNCATE ", "CREATE ", "ALTER ", "SHUTDOWN ", "GRANT ", "REVOKE ",
        "XP_", "SP_", "DBCC ", "BULK ", "CHECKPOINT ", "BACKUP ", "RESTORE "
    };

            foreach (var keyword in dangerousKeywords)
            {
                if (upperHql.Contains(keyword))
                {
                    WriteLogFile("Dangerous Operation Detected:" + keyword.Trim());
                    throw new SecurityException($"Dangerous Operation Detected: {keyword.Trim()}");
                }
            }
        }

        #region ---�ԼӴ���-----------------------------------------------------------

        //�����û�������־����־��
        public void InsertUserOperateLog(string strHQL)
        {
            string strSQL, strHQL1, strHQL2;
            string strUserCode, strUserName, strUserIP;

            try
            {
                if (System.Configuration.ConfigurationManager.AppSettings["SaveOperateLog"] == "YES")
                {
                    try
                    {
                        if (strHQL.IndexOf("BySystem") == -1 & strHQL.IndexOf("LicenseVerification") == -1)
                        {
                            if (HttpContext.Current.Session["UserCode"] != null & HttpContext.Current.Session["UserName"] != null)
                            {
                                strUserCode = HttpContext.Current.Session["UserCode"].ToString().Trim();
                                strUserName = HttpContext.Current.Session["UserName"].ToString().Trim();

                                strUserIP = HttpContext.Current.Request.UserHostAddress.Trim();

                                strHQL1 = "from ProjectMember as projectMember where projectMember.UserCode = " + "'" + strUserCode + "'";
                                strHQL1 = strHQL1.Replace(" ", "").ToUpper();
                                strHQL2 = strHQL.Replace(" ", "").ToUpper();

                                if (strHQL1 != strHQL2)
                                {
                                    strHQL = strHQL.Replace("'", "''");

                                    System.Threading.Tasks.Task.Run(() =>
                                    {
                                        try
                                        {
                                            strSQL = "Insert into T_UserOperateLog(UserCode,UserName,UserIP,OperateContent,OperateTime) ";
                                            strSQL += " Values(" + "'" + strUserCode + "'" + "," + "'" + strUserName + "'" + "," + "'" + strUserIP + "'" + "," + "'" + strHQL + "'" + ",now())";

                                            RunSqlCommand(strSQL);
                                        }
                                        catch (Exception ex)
                                        {
                                            WriteLogFile("InsertUserOperateLog Task Error: " + ex.Message);
                                        }
                                    });

                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        WriteLogFile("InsertUserOperateLog Inner Error: " + ex.Message);
                    }
                }
            }
            catch (Exception ex)
            {
                WriteLogFile("InsertUserOperateLog Outer Error: " + ex.Message);
            }
        }

        //����SQL���
        public static void RunSqlCommand(string strCmdText)
        {
            using (NpgsqlConnection myConnection = new NpgsqlConnection(
                   ConfigurationManager.ConnectionStrings["SQLCONNECTIONSTRING"].ConnectionString))
            {

                ///����Command
                NpgsqlCommand myCommand = new NpgsqlCommand(strCmdText, myConnection);
                myCommand.CommandTimeout = 600;

                ///������
                myConnection.Open();

                myCommand.ExecuteNonQuery();

                myConnection.Close();

                if (myCommand != null)
                {
                    myCommand.Dispose();
                }
            }
        }

        #endregion ---�ԼӴ���-----------------------------------------------------------


        public static void WriteLogFile(string input)
        {
            /**/
            ///ָ����־�ļ���Ŀ¼
            ///

            //string strLogDirectory = HttpContext.Current.Server.MapPath(HttpContext.Current.Server.MapPath("Doc") + "\\Log");
            //ShareClass.CreateDirectory(strLogDirectory);

            string fname;


            fname = HttpContext.Current.Server.MapPath("Doc") + "\\Log\\LogFile.txt";
            /**/
            ///�����ļ���Ϣ����

            FileInfo finfo = new FileInfo(fname);
            if (!finfo.Exists)
            {
                CreateDirectory(HttpContext.Current.Server.MapPath("Doc") + "\\Log");

                FileStream fs;
                fs = File.Create(fname);
                fs.Close();
                finfo = new FileInfo(fname);
            }

            try
            {
                /**/
                ///�ж��ļ��Ƿ�����Լ��Ƿ����2K
                if (finfo.Length > 1024 * 1024 * 10)
                {
                    /**/
                    ///�ļ�����10MB��������
                    File.Move(fname, HttpContext.Current.Server.MapPath("Doc") + "\\Log\\" + "BackupLogFile" + DateTime.Now.ToString("yyyyMMddHHMMssff") + ".txt");

                    /**/
                    ///ɾ�����ļ�
                    //finfo.Delete();
                }
            }
            catch
            {
            }
            //finfo.AppendText();
            /**/
            ///����ֻд�ļ���

            using (FileStream fs = finfo.OpenWrite())
            {
                /**/
                ///�������洴�����ļ�������д������
                StreamWriter w = new StreamWriter(fs);

                /**/
                ///����д����������ʼλ��Ϊ�ļ�����ĩβ
                w.BaseStream.Seek(0, SeekOrigin.End);

                /**/
                ///д�롰Log Entry : ��
                w.Write("\n\rLog Entry : ");

                /**/
                ///д�뵱ǰϵͳʱ�䲢����
                w.Write("{0} {1} \n\r", DateTime.Now.ToLongTimeString(),
                    DateTime.Now.ToLongDateString());

                /**/
                ///д����־���ݲ�����
                w.Write(input + "\n\r");

                /**/
                ///д��------------------------------------��������
                w.Write("\n\r------------------------------------\n\r");

                /**/
                ///��ջ��������ݣ����ѻ���������д�������
                w.Flush();

                /**/
                ///�ر�д������
                w.Close();
            }
        }

        public static int CreateDirectory(string strDirectory)
        {
            DirectoryInfo NewDirInfo;

            if (!Directory.Exists(strDirectory))
            {
                try
                {
                    Directory.CreateDirectory(strDirectory);
                    NewDirInfo = new DirectoryInfo(strDirectory);
                    NewDirInfo.Attributes = FileAttributes.Normal;
                    return 1;
                }
                catch
                {
                    return 2;
                }
            }
            else
            {
                return 3;
            }
        }
    }
}