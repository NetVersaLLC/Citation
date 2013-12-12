using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgCompleted : UserControl, ISetupPage
    {
        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;


        public PgCompleted()
        {
            InitializeComponent();
            UpdateApplicationName();
        }

        public event EventHandler MoveToNextPage;

        public void Initialize(Button cancelButton, Button nextButton, Button backButton)
        {
            _cancelButton = cancelButton;
            _nextButton = nextButton;
            _backButton = backButton;
        }

        public void DoAction()
        {
            _cancelButton.Tag = "1";
            _cancelButton.Text = "Finish";
            _backButton.Enabled = false;
            _nextButton.Enabled = false;
        }

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
    }
}