namespace CitationInstaller.SetupPages
{
    partial class PgInstallProgress
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblProgressText = new System.Windows.Forms.Label();
            this.prgInstallProgress = new System.Windows.Forms.ProgressBar();
            this.SuspendLayout();
            // 
            // lblProgressText
            // 
            this.lblProgressText.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblProgressText.Location = new System.Drawing.Point(19, 89);
            this.lblProgressText.Name = "lblProgressText";
            this.lblProgressText.Size = new System.Drawing.Size(363, 38);
            this.lblProgressText.TabIndex = 1;
            this.lblProgressText.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
            // 
            // prgInstallProgress
            // 
            this.prgInstallProgress.Location = new System.Drawing.Point(22, 130);
            this.prgInstallProgress.Name = "prgInstallProgress";
            this.prgInstallProgress.Size = new System.Drawing.Size(360, 33);
            this.prgInstallProgress.Style = System.Windows.Forms.ProgressBarStyle.Continuous;
            this.prgInstallProgress.TabIndex = 2;
            // 
            // PgInstallProgress
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.prgInstallProgress);
            this.Controls.Add(this.lblProgressText);
            this.MaximumSize = new System.Drawing.Size(400, 290);
            this.MinimumSize = new System.Drawing.Size(400, 290);
            this.Name = "PgInstallProgress";
            this.Size = new System.Drawing.Size(400, 290);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label lblProgressText;
        private System.Windows.Forms.ProgressBar prgInstallProgress;
    }
}
