using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices.ComTypes;
using System.Threading;
using System.Windows.Forms;
using CitationClient.Properties;
using System.Linq;

namespace CitationClient
{
    internal static class Program
    {
        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            LauncherJobs.KeyName = "Software\\" + Application.ProductName;

            var path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            if (ApplicationDeployment.IsNetworkDeployed)
            {
                // This will run first time the application started even after update.
                if (ApplicationDeployment.CurrentDeployment.IsFirstRun)
                {
                    LauncherJobs.CreateShortcuts(); // Create shortcuts
                    LauncherJobs.CopyOldFiles(path); // Copy old files after update.
                    // Save the Public Ket Token of the program, Uninstall string - this will be used in the Uninstaller process
                    LauncherJobs.SaveInformation();
                }
                // *********************************

                // This will run early first time the application started after the installation.
                if (LauncherJobs.IsFirstRun())
                {
                    if (LauncherJobs.PostSetupJobs())
                    {
                        LauncherJobs.SetFirstRun(false);
                    }
                    // ********************************
                }
            }

            if (args.Length > 0)
            {
                if (args[0].ToLower() == "/update")
                {
                    LauncherJobs.Update(); // Run update process
                }
                else if (args[0].ToLower() == "/uninstall")
                {
                    LauncherJobs.Uninstall();
                }
                return;
            }


            // Finaly launch citationServer
            LauncherJobs.KillServerProcess();
            var process = new Process
                {
                    StartInfo =
                        {
                            FileName = path + "\\files\\citationServer.exe",
                            WindowStyle = ProcessWindowStyle.Hidden
                        }
                };
            process.Start();
            // ************************
        }
    }
}