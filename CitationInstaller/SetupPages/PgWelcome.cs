using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgWelcome : UserControl, ISetupPage
    {
        #region Private Fields

        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;

        #endregion

        #region Constructor/Destructor

        public PgWelcome()
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
        }

        #endregion
    }
}