using Guna.UI2.WinForms;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Security.Principal;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;
using Microsoft.VisualBasic.ApplicationServices;

namespace Nhom13
{
    public partial class frmAdmin : Form
    {
        DBConnect data = new DBConnect();
        DataTable nhanVien;
        string tenNV;
        string query;

        public frmAdmin()
        {
            InitializeComponent();

        }

        public frmAdmin(string txtname)
        {
            InitializeComponent();
            tenNV = txtname;
        }
        // form dashbord
        private void tabControl1_Click(object sender, EventArgs e)
        {
            TaoMANV();
            btnImg_chekPass.Visible = false;
            btn_img_pass.Visible = false;
            txtMK2.UseSystemPasswordChar = true;

            query = "select count(ChucVu) from NHANVIEN where ChucVu='Admin';";
            nhanVien = data.getDatatable(query);
            setLabel(nhanVien, lblAdmin);

            query = "select count(ChucVu) from NHANVIEN where ChucVu='User';";
            nhanVien = data.getDatatable(query);
            setLabel(nhanVien, lblUser);

            query = "select MaNV, TenNV,SDT, ChucVu, TaiKhoan, MatKhau from NHANVIEN";
            nhanVien = data.getDatatable(query);
            dgvNhanVien.DataSource = nhanVien;
            //view user

            query = "select * from NHANVIEN where TaiKhoan='" + tenNV + "'";
            nhanVien = data.getDatatable(query);

            txtHoTen2.Text = nhanVien.Rows[0][1].ToString();
            txtEmail2.Text = nhanVien.Rows[0][2].ToString();
            txtSDT2.Text = nhanVien.Rows[0][3].ToString();
            cmbVaitroNguoiDung.Text = nhanVien.Rows[0][4].ToString();
            txtMK2.Text = nhanVien.Rows[0][6].ToString();
            txtNgaySinh2.Text = nhanVien.Rows[0][7].ToString();
            lblUserName.Text = tenNV;

        }
       
        private void setLabel(DataTable dt_table, Label lbl)
        {
            if (nhanVien.Rows.Count != 0)
            {
                lbl.Text = nhanVien.Rows[0][0].ToString();

            }
            else
            {
                lbl.Text = "0";
            }
        }
        public void clear()
        {
            txtEmail.Clear();
            txtUserName.Clear();
            txtName.Clear();
            txtPassWord.Clear();
            txtSDT.Clear();
            TimeNgaySinh.ResetText();
            txtMaNV.Clear();
            txtNhapLaiMK.Clear();
            cmbVaitro.SelectedIndex = -1;
            TaoMANV();

        }

        //From thêm nhân viên
        private void btnTaiLai_Click(object sender, EventArgs e)
        {
            clear();
        }

        private void txtName_Leave(object sender, EventArgs e)
        {
            if (txtName.Text.Length > 50 || txtName.Text.Trim().Length == 0)
            {

                this.errorProvider1.SetError(txtName, "Vui lòng nhập tên, Và không vượt quá 50 ký tự");
                txtName.Focus();
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }
    
        private void txtMaNV_Leave(object sender, EventArgs e)
        {
            if (txtMaNV.Text.Length > 50 || txtMaNV.Text.Trim().Length == 0)
            {

                this.errorProvider1.SetError(txtMaNV, "Vui lòng nhập tên, Và không vượt quá 50 ký tự");
                txtMaNV.Focus();
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }
        
        private void txtSDT_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                this.errorProvider1.SetError(txtSDT, "Vui lòng nhập Số điện thoại, Và Chỉ được phép nhấp số");

                e.Handled = true;
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }
        private void txtSDT_Leave(object sender, EventArgs e)
        {
            if(txtSDT.Text.Length <10)
            {
                this.errorProvider1.SetError(txtSDT, "Số điện thoại Phải 10 số");
                txtSDT.Focus();
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }
        private bool IsValidEmail(string email)
        {
            string pattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
            Regex regex = new Regex(pattern);

            return regex.IsMatch(email);
        }

        private void txtEmail_Leave(object sender, EventArgs e)
        {
            string email = txtEmail.Text;

            if (!IsValidEmail(email))
            {
                this.errorProvider1.SetError(txtEmail, "Vui lòng nhập email, Vd: abc@gmail.com");
                txtEmail.Focus();

            }
            else
            {
                this.errorProvider1.Clear();
            }
        }

        private void btnDangXuat_Click(object sender, EventArgs e)
        {
            frmDangNhap f1 = new frmDangNhap();
            f1.Show();
            this.Hide();
        }
    

        private void txtPassWord_TextChanged(object sender, EventArgs e)
        {
            // Hiển thị nút khi có dữ liệu trong TextBox
            btn_img_pass.Visible = !string.IsNullOrEmpty(txtPassWord.Text);
        }

        private void txtNhapLaiMK_TextChanged(object sender, EventArgs e)
        {
            // Hiển thị nút khi có dữ liệu trong TextBox
            btnImg_chekPass.Visible = !string.IsNullOrEmpty(txtNhapLaiMK.Text);
        }

        private void txtPassWord_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Ẩn mật khẩu khi nhập
            txtPassWord.UseSystemPasswordChar = true;
        }


        private void txtNhapLaiMK_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Ẩn mật khẩu khi nhập
            txtNhapLaiMK.UseSystemPasswordChar = true;
        }
        private void btnImg_chekPass_Click(object sender, EventArgs e)
        {
            txtNhapLaiMK.UseSystemPasswordChar = !txtNhapLaiMK.UseSystemPasswordChar;

            // Đảo ngược trạng thái ẩn/hiển thị mật khẩu khi nhấp vào nút
        }

        private void btn_img_pass_Click(object sender, EventArgs e)
        {
            // Đảo ngược trạng thái ẩn/hiển thị mật khẩu khi nhấp vào nút
            txtPassWord.UseSystemPasswordChar = !txtPassWord.UseSystemPasswordChar;

        }


        private void txtUserName_Leave(object sender, EventArgs e)
        {
            if (txtUserName.Text.Length > 50 || txtUserName.Text.Trim().Length == 0)
            {

                this.errorProvider1.SetError(txtUserName, "Vui lòng nhập tài khoản, Và không vượt quá 50 ký tự");
                txtUserName.Focus();
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }

        private void txtPassWord_Leave(object sender, EventArgs e)
        {
            if (txtPassWord.Text.Length > 50 || txtPassWord.Text.Trim().Length == 0)
            {

                this.errorProvider1.SetError(txtPassWord, "Vui lòng nhập passWord, Và không vượt quá 50 ký tự");
                txtPassWord.Focus();
            }
            else
            {
                this.errorProvider1.Clear();
            }
        }
        private bool IsPasswordConfirmed(string password, string confirmPassword)
        {
            return password.Equals(confirmPassword);
        }

        private void txtNhapLaiMK_Leave(object sender, EventArgs e)
        {
            string password = txtPassWord.Text;
            string confirmPassword = txtNhapLaiMK.Text;

            if (!IsPasswordConfirmed(password, confirmPassword))
            {
                MessageBox.Show("Mật khẩu xác nhận không khớp.", "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtPassWord.Clear();
                txtNhapLaiMK.Clear();
            }
        }

        private void txtUserName_TextChanged(object sender, EventArgs e)
        {
            query = "select * from NHANVIEN where TaiKhoan='" + txtUserName.Text + "'";
            nhanVien = data.getDatatable(query);
            if (nhanVien.Rows.Count == 0)
            {
                picAddUser.ImageLocation = @"C:\Users\ADMIN\Desktop\đồ án form\CNNet-main\image_pharmacy\yes.png";
            }
            else
            {
                picAddUser.ImageLocation = @"C:\Users\ADMIN\Desktop\đồ án form\CNNet-main\image_pharmacy\no.png";

            }
        }
        private void TaoMANV()
        {
            query = "select count(*) from NHANVIEN";
            int stt = (int)data.getScalar(query);
            stt++;
            txtMaNV.Text = "NV0" + stt;


        }

        private void btnDangKy_Click(object sender, EventArgs e)
        {
            string role = cmbVaitro.Text;
            string maNV = txtMaNV.Text;
            string HoTen = txtName.Text;
            string ngaySinh = TimeNgaySinh.Text;
            Int64 sdt = Int64.Parse(txtSDT.Text);
            string email = txtEmail.Text;
            string userName = txtUserName.Text;
            string password = txtPassWord.Text;

            try
            {
                query = "insert into NHANVIEN (MaNV, TenNV, NgaySinh, SDT,ChucVu, Email, TaiKhoan, MatKhau) values( '" + maNV + "', '" + HoTen + "', '" + ngaySinh + "', '" + sdt + "', '" + role + "','" + email + "', '" + userName + "', '" + password + "')";
                int k = data.getNonQuery(query);
                if (k != 0)
                {
                    MessageBox.Show("Bạn đã thêm thành công nhân viên", "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

            }
            catch (Exception)
            {
                MessageBox.Show("UserName da ton tai", "Thong bao loi", MessageBoxButtons.OK, MessageBoxIcon.Error);

            }
        }

        //View nhân viên

        private void txtSearch_TextChanged(object sender, EventArgs e)
        {
            string query = " SELECT * FROM NHANVIEN WHERE TenNV LIKE '" + txtSearch.Text + "' + '%'";
            nhanVien = data.getDatatable(query);
            dgvNhanVien.DataSource = nhanVien;
        }
        string userName;
        private void dgvNhanVien_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            userName = dgvNhanVien.Rows[e.RowIndex].Cells["TaiKhoan"].Value.ToString();
        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            string currentUser = tenNV;
            if (MessageBox.Show("Bạn có muốn xóa không ?", "Thông báo",
                MessageBoxButtons.OKCancel, MessageBoxIcon.Question) == DialogResult.OK)
            {
                if (currentUser != userName)
                {
                    query = "delete from NHANVIEN where TaiKhoan='" + userName + "'";
                    data.getNonQuery(query);
                    tabControl1_Click(sender, e);
                }
                else
                {
                    MessageBox.Show("Xóa không thành công, Vui lòng thử lại !", "Thông Báo",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);

                }
            }
        }

        //Update Thông tin nhân viên
        private void btnUpdate_Click(object sender, EventArgs e)
        {

            string role = cmbVaitroNguoiDung.Text;
            string name = txtHoTen2.Text;
            string ngaySinh = txtNgaySinh2.Text;
            Int64 sdt = Int64.Parse(txtSDT2.Text);
            string email = txtEmail2.Text;
            string pass = txtMK2.Text;

            query = "update NHANVIEN " +
                "set TenNV=N'" + name + "', Email='" + email + "', SDT='" + sdt + "', ChucVu='" + role + "', MatKhau='" + pass + "', NgaySinh='" + ngaySinh + "' " +
                "where TaiKhoan='" + tenNV + "'";
            data.getNonQuery(query);
            MessageBox.Show("Bạn đã cập nhật thành công thông tin", "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        // void
        DataTable Month = new DataTable();
        public void loadTableMonth()
        {
            Month.Columns.Add("ID");
            Month.Columns.Add("TenThang");
            Month.EndInit();
            for (int i = 1; i <= 12; i++)
            {
                DataRow newrow = Month.NewRow();
                newrow["ID"] = i;
                newrow["TenThang"] = "Tháng " + i.ToString();
                Month.Rows.Add(newrow);
            }
            comboBox1.DataSource = Month;
            comboBox1.ValueMember = "ID";
            comboBox1.DisplayMember = "TenThang";
        }
        private void frmAdmin_Load(object sender, EventArgs e)
        {
            loadTableMonth();
        }

        private void comboBox1_SelectedValueChanged(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            if (comboBox1.SelectedIndex > 0)
            {
                dt = data.getDatatable("Select * from HoaDon where Month(NgayLap)='" + comboBox1.SelectedValue.ToString() + "'");
                BaoCaoDoanhSo baoCao = new BaoCaoDoanhSo();
                baoCao.SetDataSource(dt);
                baoCao.SetDatabaseLogon("sa", "password");
                crystalReportViewer1.ReportSource = baoCao;
            }
        }

        private void tabPage1_Click(object sender, EventArgs e)
        {

        }

     

        private void btn_img_profile_Click(object sender, EventArgs e)
        {
            txtMK2.UseSystemPasswordChar = !txtMK2.UseSystemPasswordChar;
        }

        private void btn_img_profile_KeyPress(object sender, KeyPressEventArgs e)
        {
            txtMK2.UseSystemPasswordChar = true;
        }

        private void cmbVaitro_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void frmAdmin_FormClosing(object sender, FormClosingEventArgs e)
        {
            Application.Exit();
        }
    }
}
