namespace CitationInstaller.SetupPages
{
    partial class PgLicense
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
            this.rtLicense = new System.Windows.Forms.RichTextBox();
            this.chkAccept = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // rtLicense
            // 
            this.rtLicense.Dock = System.Windows.Forms.DockStyle.Top;
            this.rtLicense.Location = new System.Drawing.Point(5, 5);
            this.rtLicense.Margin = new System.Windows.Forms.Padding(5);
            this.rtLicense.Name = "rtLicense";
            this.rtLicense.Size = new System.Drawing.Size(390, 233);
            this.rtLicense.TabIndex = 0;
            this.rtLicense.Text = "";
            // 
            // chkAccept
            // 
            this.chkAccept.AutoSize = true;
            this.chkAccept.Location = new System.Drawing.Point(327, 246);
            this.chkAccept.Name = "chkAccept";
            this.chkAccept.Size = new System.Drawing.Size(65, 17);
            this.chkAccept.TabIndex = 1;
            this.chkAccept.Text = "I accept";
            this.chkAccept.UseVisualStyleBackColor = true;
            this.chkAccept.CheckedChanged += new System.EventHandler(this.chkAccept_CheckedChanged);
            // 
            // PgLicense
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.White;
            this.Controls.Add(this.chkAccept);
            this.Controls.Add(this.rtLicense);
            this.Margin = new System.Windows.Forms.Padding(5);
            this.MaximumSize = new System.Drawing.Size(400, 290);
            this.MinimumSize = new System.Drawing.Size(400, 290);
            this.Name = "PgLicense";
            this.Padding = new System.Windows.Forms.Padding(5);
            this.Size = new System.Drawing.Size(400, 290);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox rtLicense;
        private System.Windows.Forms.CheckBox chkAccept;

    }
}
