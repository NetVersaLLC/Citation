using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows.Forms;
using CitationClient.Properties;

namespace CitationClient
{
    internal static class Program
    {
        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            Process process;

            ApplicationDeployment application =
                ApplicationDeployment.CurrentDeployment;

            if (application.IsFirstRun)
            {
                string content = Resources.postinstall;
                content = content.Replace("%~1", path);
                string tempFile = Path.GetTempFileName() + ".bat";
                File.WriteAllText(tempFile, content);
                if (File.Exists(tempFile))
                {
                    process = new Process();
                    process.StartInfo.Verb = "runas";
                    process.StartInfo.FileName = tempFile;
                    process.StartInfo.WorkingDirectory = path;
#if !DEBUG
                    process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
#else
                    process.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
#endif
                    process.Start();

                    process.WaitForExit();

                    File.Delete(tempFile);
                }
            }

            process = new Process();
            process.StartInfo.FileName = path + "\\files\\citationServer.exe";
            process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            process.Start();
        }
    }
}