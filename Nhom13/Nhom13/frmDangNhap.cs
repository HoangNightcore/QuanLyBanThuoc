using Microsoft.VisualBasic.ApplicationServices;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;

namespace Nhom13
{
    public partial class frmDangNhap : Form
    {
        DBConnect data;

        string query;
        public string tenNV;
        public frmDangNhap()
        {
            data = new DBConnect();
            InitializeComponent();
            img_btnHienThiPass.Visible = false;

        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void btnDangNhap_Click(object sender, EventArgs e)
        {
            string sqlLogIn = "select * from NHANVIEN";
            DataTable NhanVien = data.getDatatable(sqlLogIn);

            if (NhanVien.Rows.Count == 0)
            {
                if (txtUserName.Text == "root" && txtPassWord.Text == "root")
                {
                    frmAdmin admin = new frmAdmin();
                    admin.Show();
                    this.Hide();
                }
            }
            else
            {
                query = "select * from NHANVIEN where TaiKhoan COLLATE SQL_Latin1_General_CP1_CS_AS = '" + txtUserName.Text + "' and MatKhau COLLATE SQL_Latin1_General_CP1_CS_AS = '" + txtPassWord.Text + "'";
       
                NhanVien = data.getDatatable(query);
                if (NhanVien.Rows.Count != 0)
                {
                    string ChucVu = NhanVien.Rows[0][4].ToString();
                    if (ChucVu == "Admin")
                    {

                        frmAdmin admin = new frmAdmin(txtUserName.Text);
                        admin.Show();
                        this.Hide();
                    }
                    else if (ChucVu == "User")
                    {
                        frm_Home user = new frm_Home(txtUserName.Text);
                        user.Show();
                        this.Hide();
                    }

                }
                else
                {
                    MessageBox.Show("Thong tin mat khau khong chinh xac !", "Thong Bao", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void txtPassWord_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Ẩn mật khẩu khi nhập
            txtPassWord.UseSystemPasswordChar = true;
        }

        private void img_btnHienThiPass_Click(object sender, EventArgs e)
        {
            // Hiển thị hoặc ẩn mật khẩu khi nhấn nút
            txtPassWord.UseSystemPasswordChar = !txtPassWord.UseSystemPasswordChar;
        }

        private void txtPassWord_TextChanged(object sender, EventArgs e)
        {
            img_btnHienThiPass.Visible = !string.IsNullOrEmpty(txtPassWord.Text);
        }
    }
}
