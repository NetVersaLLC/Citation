using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgCompleted : UserControl, ISetupPage
    {
        #region Private Fields

        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;

        #endregion

        #region Constructor/Destructor

        public PgCompleted()
        {
            InitializeComponent();
            UpdateApplicationName();
        }

        #endregion

        #region Methods

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

        #endregion

        #region ISetupPage Members

        public event EventHandler MoveToNextPage;
        public event EventHandler MoveToPreviousPage;
        public event EventHandler ExitSetup;

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

        #endregion
    }
}