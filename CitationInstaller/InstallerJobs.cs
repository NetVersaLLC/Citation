using System.Collections.Generic;
using System.Diagnostics;
using System.Windows.Forms;
using CitationInstaller.SetupPages.Dialogs;
using Microsoft.Win32;

namespace CitationInstaller
{
    public static class InstallerJobs
    {
        #region Methods

        public static bool CheckPrerequirements(Form parent)
        {
            string[] instances = GetFireFoxInstances();
            if (instances.Length == 0)
            {
                return true;
            }
            var frm = new FrmFireFoxInstances();
            if (frm.ShowDialog(parent) == DialogResult.OK)
            {
                return true;
            }
            return false;
        }

        public static bool CheckForFireFoxVersion()
        {
            object path =
                Registry.GetValue(
                    @"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe", "", null);
            if (path != null)
            {
                FileVersionInfo version = FileVersionInfo.GetVersionInfo(path.ToString());
                if (version.FileMajorPart >= 24)
                {
                    return true;
                }
            }
            return false;
        }

        public static string[] GetFireFoxInstances()
        {
            var instances = new List<string>();
            Process[] serverInstances = Process.GetProcessesByName("firefox");
            foreach (Process serverInstance in serverInstances)
            {
                instances.Add(serverInstance.MainWindowTitle);
            }
            return instances.ToArray();
        }

        #endregion
    }
}