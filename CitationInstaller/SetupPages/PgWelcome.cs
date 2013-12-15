﻿using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgWelcome : UserControl, ISetupPage
    {
        private Button _backButton;
        private Button _cancelButton;
        private Button _nextButton;


        public PgWelcome()
        {
            InitializeComponent();
            UpdateApplicationName();
        }

        public void Initialize(Button cancelButton, Button nextButton, Button backButton)
        {
            _cancelButton = cancelButton;
            _nextButton = nextButton;
            _backButton = backButton;
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
    }
}