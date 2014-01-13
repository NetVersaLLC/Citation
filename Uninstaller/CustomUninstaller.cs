using System;
using System.Diagnostics;
using System.Security.Policy;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Win32;

namespace Uninstaller
{
    public static class CustomUninstaller
    {
        #region Methods

        /// <summary>
        ///     Uninstall the current version of the application.
        /// </summary>
        public static void Uninstall(string uninstallString, bool pushOK)
        {
            // Find Uninstall string in registry    
            string DisplayName = null;
            if (uninstallString.Length <= 0)
            {
                return;
            }

            //uninstallString example: "rundll32.exe dfshim.dll,ShArpMaintain GMStudio.application, Culture=neutral, PublicKeyToken=e84b302e57430172, processorArchitecture=msil";
            string runDLL32 = uninstallString.Substring(0, 12);
            string args = uninstallString.Substring(13);

            //start the uninstall; this will bring up the uninstall dialog 
            //  asking if it's ok
            Process uninstallProcess = Process.Start(runDLL32, args);

            if (pushOK)
            {
                //push the OK button
                PushUninstallOKButton(DisplayName);
            }

            while (!uninstallProcess.HasExited)
            {
                Application.DoEvents();
                Thread.Sleep(100);
            }
        }

        public static int Uninstall(string uninstallString)
        {
            if (uninstallString.Length <= 0)
            {
                return 1;
            }

            //uninstallString example: "rundll32.exe dfshim.dll,ShArpMaintain GMStudio.application, Culture=neutral, PublicKeyToken=e84b302e57430172, processorArchitecture=msil";
            string runDLL32 = uninstallString.Substring(0, 12);
            string args = uninstallString.Substring(13);

            //start the uninstall; this will bring up the uninstall dialog 
            //  asking if it's ok
            Process uninstallProcess = Process.Start(runDLL32, args);


            while (!uninstallProcess.HasExited)
            {
                Application.DoEvents();
                Thread.Sleep(100);
            }
            return uninstallProcess.ExitCode;
        }

        /// <summary>
        ///     Find and Push the OK button on the uninstall dialog.
        /// </summary>
        /// <param name="displayName">Display Name value from the registry</param>
        private static void PushUninstallOKButton(string displayName)
        {
            bool success = false;

            //Find the uninstall dialog.
            IntPtr uninstallerWin = FindUninstallerWindow(displayName, out success);
            IntPtr OKButton = IntPtr.Zero;

            //If it found the window, look for the button.
            if (success)
                OKButton = FindUninstallerOKButton(uninstallerWin, out success);

            //If it found the button, press it.
            if (success)
                DeploymentUtilsWin32.DoButtonClick(OKButton);
        }

        /// <summary>
        ///     Find the uninstall dialog.
        /// </summary>
        /// <param name="displayName">Display Name retrieved from the registry.</param>
        /// <param name="success">Whether the window was found or not.</param>
        /// <returns>Pointer to the uninstall dialog.</returns>
        private static IntPtr FindUninstallerWindow(string displayName, out bool success)
        {
            //Max number of times to look for the window, 
            //used to let you out if there's a problem.
            int i = 25;
            var w32 = new DeploymentUtilsWin32();
            IntPtr uninstallerWindow = IntPtr.Zero;
            while (uninstallerWindow == IntPtr.Zero && i > 0)
            {
                uninstallerWindow = w32.SearchForTopLevelWindow(displayName + " Maintenance");
                Thread.Sleep(500);
                i--;
            }

            if (uninstallerWindow == IntPtr.Zero)
                success = false;
            else
                success = true;

            return uninstallerWindow;
        }

        /// <summary>
        ///     Find the OK button on the uninstall dialog.
        /// </summary>
        /// <param name="uninstallerWindow">The pointer to the Uninstall Dialog</param>
        /// <param name="success">Whether it succeeded or not.</param>
        /// <returns>A pointer to the OK button</returns>
        private static IntPtr FindUninstallerOKButton(IntPtr uninstallerWindow, out bool success)
        {
            //max number of times to look for the button, 
            //lets you out if there's a problem
            int i = 25;
            var w32 = new DeploymentUtilsWin32();
            IntPtr OKButton = IntPtr.Zero;

            while (OKButton == IntPtr.Zero && i > 0)
            {
                OKButton = w32.SearchForChildWindow(uninstallerWindow, "&OK");
                Thread.Sleep(500);
                i--;
            }

            if (OKButton == IntPtr.Zero)
                success = false;
            else
                success = true;

            return OKButton;
        }

        public static string GetPublicKeyToken()
        {
            var asi =
                new ApplicationSecurityInfo(AppDomain.CurrentDomain.ActivationContext);
            byte[] pk = asi.ApplicationId.PublicKeyToken;
            var pkt = new StringBuilder();
            for (int i = 0; i < pk.GetLength(0); i++)
                pkt.Append(String.Format("{0:x2}", pk[i]));
            return pkt.ToString();
        }

        /// <summary>
        ///     Gets the uninstall string for the current ClickOnce app from the Windows
        ///     Registry.
        /// </summary>
        /// <param name="publicKeyToken">The public key token of the app.</param>
        /// <param name="displayName"></param>
        /// <param name="keyPath"></param>
        /// <returns>The command line to execute that will uninstall the app.</returns>
        public static string GetUninstallString(string publicKeyToken, out string displayName, out string keyPath)
        {
            string uninstallString = null;

            //set up the string to search for
            string searchString = "PublicKeyToken=" + publicKeyToken;

            //open the registry key and get the subkey names 
            RegistryKey uninstallKey =
                Registry.CurrentUser.OpenSubKey("Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall");
            string[] appKeyNames = uninstallKey.GetSubKeyNames();

            displayName = null;
            keyPath = null;
            bool found = false;

            //search through the list for one with a match 
            foreach (string appKeyName in appKeyNames)
            {
                RegistryKey appKey = uninstallKey.OpenSubKey(appKeyName);
                uninstallString = (string) appKey.GetValue("UninstallString");
                displayName = (string) appKey.GetValue("DisplayName");
                appKey.Close();
                if (uninstallString.Contains(publicKeyToken) /*&& displayName == Application.ProductName*/)
                {
                    found = true;
                    keyPath = "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\" + appKeyName;
                    break;
                }
            }

            uninstallKey.Close();

            if (found)
                return uninstallString;
            else
                return string.Empty;
        }

        public static string GetUninstallString(string publicKeyToken, out string keyPath)
        {
            string displayName = "";
            keyPath = "";
            return GetUninstallString(publicKeyToken, out displayName, out keyPath);
        }

        #endregion
    }
}