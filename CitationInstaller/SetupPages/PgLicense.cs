using System;
using System.Windows.Forms;
using CitationInstaller.Properties;

namespace CitationInstaller.SetupPages
{
    public partial class PgLicense : UserControl, ISetupPage
    {
        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;


        public PgLicense()
        {
            InitializeComponent();
            UpdateApplicationName();

            string rtf = Resources.license;
            rtLicense.Rtf = rtf;
        }

        public void Initialize(Button cancelButton, Button nextButton, Button backButton)
        {
            _cancelButton = cancelButton;
            _nextButton = nextButton;
            _backButton = backButton;

            _nextButton.Enabled = false;
        }

        public void DoAction()
        {
        }

        public event EventHandler MoveToNextPage;

        private void UpdateApplicationName()
        {
            foreach (object ctrl in Controls)
            {
                if (ctrl.GetType() == typeof (Label))
                {
                    var label = ctrl as Label;
                    label.Text = label.Text.Replace("#ApplicationName#", Application.ProductName);
                }
            }
        }

        private void chkAccept_CheckedChanged(object sender, EventArgs e)
        {
            _nextButton.Enabled = chkAccept.Checked;
        }
    }
}