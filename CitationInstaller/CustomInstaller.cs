using System;
using System.Deployment.Application;
using System.Windows.Forms;

namespace CitationInstaller
{
    public class CustomInstaller
    {
        public InPlaceHostingManager InPlaceHostingManager { get; set; }
        public string ProductName { get; set; }

        public event EventHandler<DownloadProgressChangedEventArgs> DownloadProgressChanged;
        public event EventHandler<DownloadApplicationCompletedEventArgs> DownloadApplicationCompleted;
        public event EventHandler ErrorHandled;

        protected virtual void OnErrorHandled()
        {
            EventHandler handler = ErrorHandled;
            if (handler != null) handler(this, EventArgs.Empty);
        }

        protected virtual void OnDownloadApplicationCompleted(DownloadApplicationCompletedEventArgs e)
        {
            EventHandler<DownloadApplicationCompletedEventArgs> handler = DownloadApplicationCompleted;
            if (handler != null) handler(this, e);
        }

        protected virtual void OnDownloadProgressChanged(DownloadProgressChangedEventArgs e)
        {
            EventHandler<DownloadProgressChangedEventArgs> handler = DownloadProgressChanged;
            if (handler != null) handler(this, e);
        }

        public void InstallApplication(string deployManifestUriStr)
        {
            try
            {
                var deploymentUri = new Uri(deployManifestUriStr);
                InPlaceHostingManager = new InPlaceHostingManager(deploymentUri, false);
            }
            catch (UriFormatException uriEx)
            {
                OnErrorHandled();
                MessageBox.Show("Cannot install the application: " +
                                "The deployment manifest URL supplied is not a valid URL. " +
                                "Error: " + uriEx.Message);
                return;
            }
            catch (PlatformNotSupportedException platformEx)
            {
                OnErrorHandled();
                MessageBox.Show("Cannot install the application: " +
                                "This program requires Windows XP or higher. " +
                                "Error: " + platformEx.Message);
                return;
            }
            catch (ArgumentException argumentEx)
            {
                OnErrorHandled();
                MessageBox.Show("Cannot install the application: " +
                                "The deployment manifest URL supplied is not a valid URL. " +
                                "Error: " + argumentEx.Message);
                return;
            }

            InPlaceHostingManager.GetManifestCompleted += iphm_GetManifestCompleted;
            InPlaceHostingManager.GetManifestAsync();
        }

        private void iphm_GetManifestCompleted(object sender, GetManifestCompletedEventArgs e)
        {
            // Check for an error. 
            if (e.Error != null)
            {
                OnErrorHandled();
                // Cancel download and install.
                MessageBox.Show("Could not download manifest. Error: " + e.Error.Message);
                return;
            }

            // bool isFullTrust = CheckForFullTrust(e.ApplicationManifest); 

            // Verify this application can be installed. 
            try
            {
                // the true parameter allows InPlaceHostingManager 
                // to grant the permissions requested in the applicaiton manifest.
                InPlaceHostingManager.AssertApplicationRequirements(true);
            }
            catch (Exception ex)
            {
                OnErrorHandled();
                MessageBox.Show("An error occurred while verifying the application. " +
                                "Error: " + ex.Message);
                return;
            }
            ProductName = e.ProductName;
            // Use the information from GetManifestCompleted() to confirm  
            // that the user wants to proceed. 
            //string appInfo = "Application Name: " + e.ProductName;
            //appInfo += "\nVersion: " + e.Version;
            //appInfo += "\nSupport/Help Requests: " + (e.SupportUri != null ?
            //    e.SupportUri.ToString() : "N/A");
            //appInfo += "\n\nConfirmed that this application can run with its requested permissions.";
            //// if (isFullTrust) 
            //// appInfo += "\n\nThis application requires full trust in order to run.";
            //appInfo += "\n\nProceed with installation?";

            //DialogResult dr = MessageBox.Show(appInfo, "Confirm Application Install",
            //    MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            //if (dr != System.Windows.Forms.DialogResult.OK)
            //{
            //    return;
            //}

            // Download the deployment manifest. 
            InPlaceHostingManager.DownloadProgressChanged += iphm_DownloadProgressChanged;
            InPlaceHostingManager.DownloadApplicationCompleted += iphm_DownloadApplicationCompleted;

            try
            {
                // Usually this shouldn't throw an exception unless AssertApplicationRequirements() failed,  
                // or you did not call that method before calling this one.
                InPlaceHostingManager.DownloadApplicationAsync();
            }
            catch (Exception downloadEx)
            {
                OnErrorHandled();
                MessageBox.Show("Cannot initiate download of application. Error: " +
                                downloadEx.Message);
                return;
            }
        }

        private void iphm_DownloadApplicationCompleted(object sender, DownloadApplicationCompletedEventArgs e)
        {
            OnDownloadApplicationCompleted(e);
        }

        private void iphm_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            OnDownloadProgressChanged(e);
        }
    }

    [AttributeUsage(AttributeTargets.Assembly)]
    public class AssemblyPublishUrlAttribute : Attribute
    {
        private string _publishUrl;
        public AssemblyPublishUrlAttribute(string url)
        {
            PublishUrl = url;
        }

        public string PublishUrl
        {
            get { return _publishUrl; }
            set { _publishUrl = value; }
        }
    }
}