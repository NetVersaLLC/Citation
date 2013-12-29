using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgPrerequirements : UserControl, ISetupPage
    {
        #region Private Fields

        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;

        #endregion

        #region Constructor/Destructor

        public PgPrerequirements()
        {
            InitializeComponent();
            UpdateApplicationName();
        }

        #endregion

        #region Methods

        protected virtual void OnExitSetup()
        {
            EventHandler handler = ExitSetup;
            if (handler != null) handler(this, EventArgs.Empty);
        }

        protected virtual void OnMoveToNextPage()
        {
            EventHandler handler = MoveToNextPage;
            if (handler != null) handler(this, EventArgs.Empty);
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

        #endregion

        #region ISetupPage Members

        public event EventHandler ExitSetup;
        public event EventHandler MoveToNextPage;
        public event EventHandler MoveToPreviousPage;

        public void Initialize(Button cancelButton, Button nextButton, Button backButton)
        {
            _cancelButton = cancelButton;
            _nextButton = nextButton;
            _backButton = backButton;
        }

        public void DoAction()
        {
            _nextButton.Enabled = false;
            if (InstallerJobs.CheckPrerequirements(FindForm()))
            {
                _nextButton.Enabled = true;
                OnMoveToNextPage();
            }
            else
                OnExitSetup();
        }

        #endregion
    }
}