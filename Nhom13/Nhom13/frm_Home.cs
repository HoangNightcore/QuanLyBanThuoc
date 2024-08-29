using Guna.UI2.WinForms;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using DGVPrinterHelper;
using System.Data.SqlClient;

namespace Nhom13
{
    public partial class frm_Home : Form
    {
        string strConnect = @"Data Source=LAPTOP-CV1CRQMN\SQLEXPRESS;Initial Catalog=BanThuoc;Integrated Security=True";
        SqlConnection sqlcon = null;

        DBConnect data = new DBConnect();
        DataTable thuoc;
        string MaNV = "NV001";
        string tenNV;
        string query;
        public frm_Home()
        {
            InitializeComponent();
        }
        public frm_Home(string txtname)
        {
            InitializeComponent();
            tenNV = txtname;
        }


        private void tabPage2_Click(object sender, EventArgs e)
        {

        }

        private void btnDangXuat_Click(object sender, EventArgs e)
        {
            frmDangNhap f1 = new frmDangNhap();
            f1.Show();
            this.Hide();
        }

        private void tabControl1_Click(object sender, EventArgs e)
        {
            LstBoxMedicine.Items.Clear();
            query = "select TenThuoc from THUOC";
            thuoc = data.getDatatable(query);
            for (int i = 0; i < thuoc.Rows.Count; i++)
            {
                LstBoxMedicine.Items.Add(thuoc.Rows[i][0].ToString());
            }
        }

        private void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LstBoxMedicine.Items.Clear();
            if (chkThuocCoDon.Checked == true && chkThuocTuongTu.Checked == true)
            {
                query = "EXEC SearchThuoC '" + txtSearch.Text + "'";
            }
            else if (chkThuocCoDon.Checked)
            {
                query = "EXEC SearchThuoCByNhom N'" + txtSearch.Text + "'";
            }
            else if (chkThuocTuongTu.Checked)
            {
                query = "EXEC SearchThuoCByLoai N'" + txtSearch.Text + "'";
            }
            else
            {
                query = "EXEC SearchThuoCByTenThuoc '" + txtSearch.Text + "'";
            }

            thuoc = data.getDatatable(query);
            for (int i = 0; i < thuoc.Rows.Count; i++)
            {
                LstBoxMedicine.Items.Add(thuoc.Rows[i][0].ToString());
            }
        }

        private void txtSoLuong_TextChanged(object sender, EventArgs e)
        {
            if (txtSoLuong.Text != "")
            {
                string maLo = cmbLoThuoc.SelectedValue.ToString();
                string idThuoc = txtThuocID.Text;

                double inputValue = double.Parse(txtGiaMoiDonVi.Text);

                // Chuyển đổi từ số thực sang số nguyên
                Int64 uniPrice = Convert.ToInt64(inputValue);
                Int64 noOfUnit = Int64.Parse(txtSoLuong.Text);

                query = "SELECT dbo.FC_CHECKSL('" + maLo + "', '" + idThuoc + "', " + noOfUnit + ") ";
                object result = data.getScalar(query);

                if ((int)result == -1)
                {
                    MessageBox.Show("Vui lòng nhập lại số lượng mua, Số lượng hiện tại trong lô không đủ", "Thông Báo",
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                    txtSoLuong.Clear();
                    txtSoLuong.Focus();
                }

                else
                {
                    Int64 totalAmount = uniPrice * noOfUnit;
                    txtTongGia.Text = totalAmount.ToString();
                }

              
            }
            else
            {
                txtTongGia.Clear();
            }
        }

        private void LstBoxMedicine_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtSoLuong.Clear();
            string name = LstBoxMedicine.GetItemText(LstBoxMedicine.SelectedItem);
            txtTenThuoc.Text = name;
            query = "select Thuoc.MaThuoc, NgayHetHan, GiaBan from THUOC ,CHITIETPHIEUNHAP,LoThuoc where TenThuoc Like'%" + name + "%'and Thuoc.MaThuoc=CHITIETPHIEUNHAP.MaThuoc ;";
            thuoc = data.getDatatable(query);
            txtThuocID.Text = thuoc.Rows[0][0].ToString();
            txtNgayHetHan.Text = thuoc.Rows[0][1].ToString();
            txtGiaMoiDonVi.Text = thuoc.Rows[0][2].ToString();

            query = "select MaLo from LOTHUOC, THUOC where LOTHUOC.MaLoaiThuoc= THUOC.MaLoaiThuoc  and TenThuoc like '%" + name + "%' ORDER BY NgayHetHan ASC";
            cmbLoThuoc.DisplayMember = "MaLo";
            cmbLoThuoc.ValueMember = "MaLo";
            cmbLoThuoc.DataSource = data.getDatatable(query);


        }
        private void clearALL()
        {
            txtTenThuoc.Clear();
            txtThuocID.Clear();
            txtNgayHetHan.ResetText();
            txtGiaMoiDonVi.ResetText();
            txtTongGia.Clear();
            txtSoLuong.Clear();
            txtSearch.Clear();
        }

        private void btnLoaiLai_Click(object sender, EventArgs e)
        {
            clearALL();
        }
        protected int n, totalAmount = 0;
        protected Int64 quantity, newquanTity;

        private void btnAddToCard_Click(object sender, EventArgs e)
        {
            if (txtThuocID.Text != "")
            {
                query = "select SoLuongTon, MaLo from LOTHUOC, THUOC where LOTHUOC.MaLoaiThuoc = THUOC.MaLoaiThuoc and THUOC.MaThuoc='" + txtThuocID.Text + "' ;";
                thuoc = data.getDatatable(query);
                quantity = Int64.Parse(thuoc.Rows[0][0].ToString());
                string maLo = cmbLoThuoc.SelectedValue.ToString();
                newquanTity = Int64.Parse(txtSoLuong.Text);
                string malp = cmbLoThuoc.Text.ToString();

                
                if (newquanTity > 0)
                {
                    n = lstDanhSachThuoc.Rows.Add();
                    lstDanhSachThuoc.Rows[n].Cells[0].Value = txtThuocID.Text;
                    lstDanhSachThuoc.Rows[n].Cells[1].Value = txtTenThuoc.Text;
                    lstDanhSachThuoc.Rows[n].Cells[2].Value = txtNgayHetHan.Text;
                    lstDanhSachThuoc.Rows[n].Cells[3].Value = txtGiaMoiDonVi.Text;
                    lstDanhSachThuoc.Rows[n].Cells[4].Value = txtSoLuong.Text;
                    lstDanhSachThuoc.Rows[n].Cells[5].Value = txtTongGia.Text;

                    totalAmount = totalAmount + int.Parse(txtTongGia.Text);
                    LblTongTien.Text = "Tổng =" + totalAmount.ToString();
                 

                    string mathuoc = txtThuocID.Text;

                    query = "SELECT dbo.LAYSOTON('" + maLo + "', '"+mathuoc+"') ";
                    object result = data.getScalar(query);
                    int SLconLai = (int)result - (int)newquanTity;
                    // Cập Nhật số lượng còn lại trong lô
                    query = "EXEC CAPNHATSL '"+maLo+"', '"+mathuoc+"', "+ SLconLai + "";
                    data.getNonQuery(query);

                    MessageBox.Show("Thuốc đã được thêm vào giỏ hàng", "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Information);

                }
                else
                {
                    MessageBox.Show("bạn đã không thêm thuốc thành công vào giỏ hàng \n Thuốc hiện tại đã hết hàng " + quantity, "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                clearALL();
            }
            else
            {
                MessageBox.Show("Vui lòng hãy chọn thuốc", "Thông tin", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        int TongTien;
        string IDThuoc;
        protected Int64 soLuong;

        private void lstDanhSachThuoc_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            TongTien = int.Parse(lstDanhSachThuoc.Rows[e.RowIndex].Cells[5].Value.ToString());
            IDThuoc = lstDanhSachThuoc.Rows[e.RowIndex].Cells[0].Value.ToString();
            soLuong = Int64.Parse(lstDanhSachThuoc.Rows[e.RowIndex].Cells[4].Value.ToString());
        }


        DataTable dsSanPham = new DataTable();
        private void lsb_Sanpham_SelectedIndexChanged(object sender, EventArgs e)
        {
            dsSanPham = new DataTable();
            string chose = lsb_Sanpham.SelectedValue.ToString();
            dsSanPham = data.getDatatable("Select * from Thuoc where MaloaiThuoc = '" + lsb_Sanpham.SelectedValue.ToString() + "'");
            DataColumn[] key = new DataColumn[1];
            key[0] = dsSanPham.Columns[0];
            dsSanPham.PrimaryKey = key;
            cmb_Timsp.DataSource = dsSanPham;
            if (cmb_Timsp.Items.Count == 0)
                cmb_Timsp.Text = "None";
            cmb_Timsp.DisplayMember = "TenThuoc";
            cmb_Timsp.ValueMember = "MaThuoc";
            Binding();
        }
        public void Binding()
        {

            txt_NH_DonGia.DataBindings.Clear();
            txt_NH_DonGia.DataBindings.Add("Text", cmb_Timsp.DataSource, "GiaBan");
            txt_NH_MaSP.DataBindings.Clear();
            txt_NH_MaSP.DataBindings.Add("Text", cmb_Timsp.DataSource, "MaThuoc");
            txt_NH_SLSP.Text = "1";
        }
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        // Sự kiện Load
        DataTable ChiTietPhieuNhap = new DataTable();
        private void frm_Home_Load(object sender, EventArgs e)
        {
            if (sqlcon == null)
            {
                sqlcon = new SqlConnection(strConnect);
            }
            if (sqlcon.State == ConnectionState.Closed)
            {
                sqlcon.Close();
            }

            //DataTable dt = data.getDatatable("Select * from LoaiThuoc");
            //lsb_Sanpham.DataSource = dt;
            //lsb_Sanpham.ValueMember = "MaLoaiThuoc";
            //lsb_Sanpham.DisplayMember = "TenLoaiThuoc";
            // tao bảng phiếu nhập
            ChiTietPhieuNhap.Columns.Add("Mã Sản Phẩm", typeof(string));
            ChiTietPhieuNhap.Columns.Add("Tên Sản Phẩm", typeof(string));
            ChiTietPhieuNhap.Columns.Add("Giá nhập", typeof(string));
            ChiTietPhieuNhap.Columns.Add("Số lượng", typeof(string));
            ChiTietPhieuNhap.Columns.Add("Thành tiền", typeof(string));
            ChiTietPhieuNhap.Columns.Add("Ngày hết han", typeof(DateTime));
            DataColumn[] key = new DataColumn[1];
            key[0] = ChiTietPhieuNhap.Columns[0];
            ChiTietPhieuNhap.PrimaryKey = key;
            ChiTietPhieuNhap.EndInit();
            DGV_NH_DSSP.DataSource = ChiTietPhieuNhap;
            // Load Ten NV
            txt_NH_TenNV.Text = tenNV;
            txt_NH_MaNV.Text = MaNV;
            /// KHAI
            load_lstNhomThuoc_KiemKe();
            txtSoLuongTonKK.Enabled = false;
            // Khoa (load báo cáo cho trang báo cáo)
            LoadBaoCao();
            loadPhieuNhap();

        }

        private void cmb_Timsp_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void label13_Click(object sender, EventArgs e)
        {

        }
        int tongNH = 0;
        private void btn_NH_Them_Click(object sender, EventArgs e)
        {

            DataRow add = ChiTietPhieuNhap.NewRow();
            double dongia = double.Parse(txt_NH_DonGia.Text);
            int sl = int.Parse(txt_NH_SLSP.Text);
            add[0] = cmb_Timsp.SelectedValue;
            add[1] = cmb_Timsp.Text;
            add[3] = sl;
            add[2] = txt_NH_DonGia.Text;
            add[4] = (dongia * sl).ToString();
            add[5] = DTP_NH_NgayHetHan.Text;
            tongNH = tongNH + int.Parse(add[4].ToString());
            //      --------------------------------------------------  Thêm định dạng tiền -------------------------------- 
            txt_NH_tongcong.Text = tongNH.ToString("") + " VND";
            DataRow datarow = ChiTietPhieuNhap.Rows.Find(cmb_Timsp.SelectedValue);
            if (datarow == null)
                ChiTietPhieuNhap.Rows.Add(add);
            else datarow["Số lượng"] = (int.Parse(datarow["Số lượng"].ToString()) + int.Parse(add[3].ToString())).ToString();
            DGV_NH_DSSP.Refresh();
        }

        private void tabControl1_Selected(object sender, TabControlEventArgs e)
        {

        }

        private void DGV_NH_DSSP_SelectionChanged(object sender, EventArgs e)
        {

        }

        private void btn_NH_XoaSP_Click(object sender, EventArgs e)
        {
            if (DGV_NH_DSSP.SelectedRows.Count > 0 && !DGV_NH_DSSP.SelectedRows[0].IsNewRow)
            {
                DGV_NH_DSSP.Rows.Remove(DGV_NH_DSSP.SelectedRows[0]);
            }
        }



        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            if (DGV_NH_DSSP.Rows.Count != 0)
            {
                // Thêm phiếu nhập
                data.getNonQuery("insert into PhieuNhap values('" + txt_NH_MaPN.Text + "','" + DateTime.Today.ToString() + "','a','" + txt_NH_DonGia.Text + "','" + txt_NH_MaNV.Text + "','" + cmb_NH_NCC.SelectedValue.ToString() + "')");
                // Thêm chi tiết Phiếu nhâp

                foreach (DataGridViewRow item in DGV_NH_DSSP.Rows)
                {
                    int k = (int)data.getScalar("select count(*) from CHITIETPHIEUNHAP ");
                    k = k + 1;
                    string MaChiTiet = "CTPN" + k.ToString("000");
                    string MaThuoc = item.Cells[0].Value.ToString();
                    data.getNonQuery("insert into CHITIETPHIEUNHAP values('" + MaChiTiet + "','" + txt_NH_MaPN.Text + "','" + MaThuoc + "','" + txt_NH_SLSP.Text + "','" + txt_NH_DonGia.Text + "')");
                    int z = (int)data.getScalar("Select count(*) from LoThuoc");
                    z = z + 1;
                    string MaLo = "ML" + z.ToString("000");
                    data.getNonQuery("insert into LoThuoc values('" + MaLo + "','1','" + txt_NH_SLSP.Text + "','" + DTP_NH_NgayHetHan.Value.ToString("yyyy-MM-dd") + "','" + MaChiTiet + "')");

                    //update số lượng thuốc
                    data.getNonQuery("update Thuoc set soluong = soluong +'" + txt_NH_SLSP + "' where MaThuoc ='" + MaThuoc + "'");
                }
            }

        }

        private void btnRemove_Click(object sender, EventArgs e)
        {
            if (IDThuoc != null)
            {
                try
                {
                    lstDanhSachThuoc.Rows.RemoveAt(this.lstDanhSachThuoc.SelectedRows[0].Index);
                }
                catch (Exception)
                {

                }
                finally
                {
                    query = "select  SoLuongTon,MaLo from LOTHUOC, THUOC where LOTHUOC.MaLoaiThuoc = THUOC.MaLoaiThuoc and THUOC.MaThuoc='" + IDThuoc + "';";
                    thuoc = data.getDatatable(query);
                    quantity = Int64.Parse(thuoc.Rows[0][0].ToString());
                    newquanTity = quantity + soLuong;
                    query = "UPDATE LOTHUOC" +
                        " SET LOTHUOC.SoLuongTon = '" + newquanTity + "' " +
                        "FROM LOTHUOC INNER JOIN THUOC ON LOTHUOC.MaLo = THUOC.MaLoaiThuoc " +
                        "WHERE THUOC.MaThuoc = '" + IDThuoc + "';";
                    data.getNonQuery(query);

                    totalAmount = totalAmount - TongTien;
                    LblTongTien.Text = "Tổng = " + totalAmount.ToString();
                    MessageBox.Show("Thuốc đã được loại bỏ", "Thông tin", MessageBoxButtons.OK, MessageBoxIcon.Information);

                }
                tabControl1_Click(sender, e);
                clearALL();

            }
        }
        //
        private void btnThanhToanVaIn_Click(object sender, EventArgs e)
        {
            DGVPrinter print = new DGVPrinter();
            //Thông tin in 
            print.Title = "Hóa Đơn Thuốc HUIT";
            print.SubTitle = string.Format("Ngày:{0}", DateTime.Now.ToString("dd/MM/yyyy"));
            print.SubTitleFormatFlags = StringFormatFlags.LineLimit | StringFormatFlags.NoClip;
            print.PageNumbers = true;
            print.PageNumberInHeader = false;
            print.PorportionalColumns = true;
            print.HeaderCellAlignment = StringAlignment.Near;
            // Thưc hiện in ấn

            print.Footer = "Tổng số tiền phải trả: " + LblTongTien.Text.ToString() + "đ";
            print.FooterSpacing = 15;
            print.PrintDataGridView(lstDanhSachThuoc);


            //Cập nhật CTHD

            DateTime homNay = DateTime.Today;
            String strDate = homNay.ToString("dd") + homNay.ToString("MM");
            int dg = 0;
            String strNgay = homNay.ToString("yyyy-MM-dd");
            string sql = "select count(MaHD) from HOADON where NgayLap='" + strNgay + "'";
            int stt = (int)data.getScalar(sql);
            stt++;
            String strStt = stt.ToString("000");
            String maHD = "HD" + strDate + strStt;

            //lấy MANV

            DataTable nhanVien = new DataTable();
            query = "select MaNV from NHANVIEN where TaiKhoan='" + tenNV + "';";
            nhanVien = data.getDatatable(query);
            string manv = nhanVien.Rows[0][0].ToString();

            //Thêm vào bảng Hoa Don
            String maPN = "HD" + strDate + strStt;
            //sql = "insert into HOADON(MaHD, NgayLap,MaNV, TongTien) values('" + maHD + "','" + strNgay + "','" + manv + "'," + totalAmount.ToString() + ")";
            sql = "insert into HOADON(MaHD, NgayLap,MaNV) values('" + maHD + "','" + strNgay + "','" + manv + "')";

            data.getNonQuery(sql);

            // Thêm vào bảng CTHD

            foreach (DataGridViewRow row in lstDanhSachThuoc.Rows)
            {
                if (!row.IsNewRow)
                {
                    string maThuoc = row.Cells[0].Value.ToString();
                    string giaMoiDonVi = row.Cells[3].Value.ToString();
                    string soLuong = row.Cells[4].Value.ToString();


                    sql = "INSERT INTO CHITIETHD VALUES ('" + maHD + "', '" + maThuoc + "', '" + soLuong + "', '" + giaMoiDonVi + "')";
                    data.getNonQuery(sql);


                }
            }



            //Cập lại dữ liệu
            totalAmount = 0;
            LblTongTien.Text = "Tổng: 00đ ";
            lstDanhSachThuoc.DataSource = 0;
            MessageBox.Show("Bạn đã in thành công hóa đơn", "Thông Báo", MessageBoxButtons.OK, MessageBoxIcon.Information);


        }
        // Kiểm kê hàng hóa (Khải)
        private DataGridViewTextBoxColumn newCol(string name)
        {
            DataGridViewTextBoxColumn Col = new DataGridViewTextBoxColumn();
            Col.HeaderText = name;
            Col.ValueType = typeof(int);
            return Col;
        }
        private void load_lstNhomThuoc_KiemKe()
        {
            //string query = "select * from LoaiThuoc";
            //DataTable dt = data.getDatatable(query);

            //lstNhomThuocKiemKe.DataSource = dt;
            //lstNhomThuocKiemKe.DisplayMember = "TenLoaiThuoc";
            //lstNhomThuocKiemKe.ValueMember = "MaLoaiThuoc";
        }

        private void load_cboThuoc_KiemKe(string MaLoaiThuoc)
        {
            MaLoaiThuoc = lstNhomThuocKiemKe.SelectedValue.ToString();

            string query = "select * from thuoc where MaLoaiThuoc = '" + MaLoaiThuoc + "'";

            DataTable dt = data.getDatatable(query);

            cboTenThuocKK.DataSource = dt;
            cboTenThuocKK.ValueMember = "MaThuoc";
            cboTenThuocKK.DisplayMember = "TenThuoc";


            txtMaThuocKK.DataBindings.Clear();
            txtMaThuocKK.DataBindings.Add("Text", dt, "MaThuoc");
            txtMaLoaiKK.DataBindings.Clear();
            txtMaLoaiKK.DataBindings.Add("Text", dt, "MaLoaiThuoc");
            txtNhomThuocKK.DataBindings.Clear();
            txtNhomThuocKK.DataBindings.Add("Text", dt, "MaNhomThuoc");
            txtXuatXuKK.DataBindings.Clear();
            txtXuatXuKK.DataBindings.Add("Text", dt, "XuatXu");
            txtSoLuongTonKK.DataBindings.Clear();
            txtSoLuongTonKK.DataBindings.Add("Text", dt, "SoLuong");

        }



        private void load_dgvLoThuoc_KiemKe(string maThuoc)
        {
            dgvLoThuocKK.AllowUserToAddRows = false;

            string query = "select * from LoThuoc ,CHITIETPHIEUNHAP where LoThuoc.MaCTPN=CHITIETPHIEUNHAP.MaCTPN and MaThuoc = '" + maThuoc + "'";

            DataTable dt = data.getDatatable(query);
            dgvLoThuocKK.DataSource = dt;

            dgvLoThuocKK.Columns[0].HeaderText = "Mã lô";
            dgvLoThuocKK.Columns[1].HeaderText = "Số lô";
            dgvLoThuocKK.Columns[2].HeaderText = "Số lượng tồn";
            dgvLoThuocKK.Columns[3].HeaderText = "Hạn sử dụng";
            dgvLoThuocKK.Columns[4].HeaderText = "Mã thuốc";


            txtMaLoKK.DataBindings.Clear();
            txtMaLoKK.DataBindings.Add("Text", dt, "MaLo");
            txtSoLuongThucKK.DataBindings.Clear();
            txtSoLuongThucKK.DataBindings.Add("Text", dt, "SoLuongTon");


        }
        private void cboTenThuocKK_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtChenhLech.Clear();
            string maThuoc = cboTenThuocKK.SelectedValue.ToString();
            load_dgvLoThuoc_KiemKe(maThuoc);
        }

        private void UpdateSoLuongTon_Chenhlech()
        {
            try
            {
                int tongSoluongTonThucTe = 0;
                foreach (DataGridViewRow row in dgvLoThuocKK.Rows)
                {
                    tongSoluongTonThucTe += Convert.ToInt32(row.Cells["SoLuongTon"].Value);
                }

                int soLuong = Convert.ToInt32(txtSoLuongTonKK.Text);
                int chenhLech = tongSoluongTonThucTe - soLuong;

                txtChenhLech.Text = chenhLech.ToString();

            }
            catch { }
            dgvLoThuocKK.Refresh();



        }

        ds_ChenhLech dsChenhLech = new ds_ChenhLech();
        private void btnSuaKK_Click(object sender, EventArgs e)
        {
            UpdateSoLuongTon_Chenhlech();
            update_LoThuoc();


        }

        bool check_UpdateSLTon_kk = false;
        private void update_Thuoc()
        {
            string maThuoc = txtMaThuocKK.Text.Trim();
            int soluong = Convert.ToInt32(txtSoLuongTonKK.Text);


            string query = "update thuoc set SoLuong = " + soluong + " where MaThuoc = '" + maThuoc + "'";

            int kq = data.getNonQuery(query);
            if (kq > 0)
            {
                check_UpdateSLTon_kk = true;
            }
            else
            {
                MessageBox.Show("Cập nhật số lượng tồn thất bại");
            }
        }

        private void update_LoThuoc()
        {
            int index = dgvLoThuocKK.CurrentCell.RowIndex;

            string maLo = dgvLoThuocKK.Rows[index].Cells["MaLo"].Value.ToString();
            int soLuong = Convert.ToInt32(dgvLoThuocKK.Rows[index].Cells["SoLuongTon"].Value);

            string query = "update LoThuoc set SoLuongTon = " + soLuong + " where MaLo = '" + maLo + "'";
            int kq = data.getNonQuery(query);

            if (kq > 0)
            {
                MessageBox.Show("Cập nhật số lượng thành công.", "Thông báo");
            }
            else
            {
                MessageBox.Show("Cập nhật số lượng thất bại.", "Thông báo");
            }


        }

        private void update_dsChenhLech()
        {

            string maThuoc = txtMaThuocKK.Text;
            foreach (DataRow dr in dsChenhLech.Tables["ChenhLechKiemKe"].Rows)
            {
                if (maThuoc == dr["MaThuoc"].ToString())
                {
                    dr["ChenhLech"] = txtChenhLech.Text;
                }
            }

        }

        private void btnLuuKK_Click(object sender, EventArgs e)
        {
            UpdateSoLuongTon_Chenhlech();

            try
            {
                int value = Convert.ToInt32(txtChenhLech.Text);
                if (value != 0)
                {
                    MessageBox.Show("Số lượng thuốc có sự chênh lệch.", "Nhắc nhở");
                    return;
                }

                MessageBox.Show("Lưu thành công", "Thông báo", MessageBoxButtons.OK);

                update_dsChenhLech();

                update_Thuoc();
                if (check_UpdateSLTon_kk == true)
                {
                    check_UpdateSLTon_kk = false;
                }


            }
            catch
            {
                MessageBox.Show("Vui lòng nhập số lượng kiểm kê");
            }

        }
        private void btnPhieuKiemKe_Click(object sender, EventArgs e)
        {


            txtSoLuongTonKK.Enabled = true;

            rpt_KiemKe rpt = new rpt_KiemKe();
            rpt.SetDataSource(dsChenhLech.Tables["ChenhLechKiemKe"]);

            frm_Report_KiemKe reportForm = new frm_Report_KiemKe();
            reportForm.crystalReportViewer1.ReportSource = rpt;
            reportForm.ShowDialog();



        }

        private void lstNhomThuocKiemKe_SelectedIndexChanged(object sender, EventArgs e)
        {
            string MaNhomThuoc = lstNhomThuocKiemKe.SelectedValue.ToString();
            load_cboThuoc_KiemKe(MaNhomThuoc);
        }




        private void btnLuuChenhLech_Click(object sender, EventArgs e)
        {

            if (txtChenhLech.Text == "")
            {
                MessageBox.Show("Vui lòng nhập số lượng thực tế.", "Nhắc nhở");
                return;
            }


            DataTable dt = dsChenhLech.Tables["ChenhLechKiemKe"];

            foreach (DataRow row1 in dt.Rows)
            {
                if (row1["MaThuoc"].ToString() == txtMaThuocKK.Text)
                {
                    DialogResult a = MessageBox.Show("Bạn có muốn lưu lại chênh lệch của thuốc này?", "Thông báo", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                    if (a == DialogResult.Yes)
                    {
                        update_dsChenhLech();
                        MessageBox.Show("Cập nhật thành công", "Thông báo");
                        return;
                    }
                    else
                    {
                        return;
                    }

                }
            }

            int SoLuongThuc = 0;
            foreach (DataGridViewRow dvr in dgvLoThuocKK.Rows)
            {
                SoLuongThuc += Convert.ToInt32(dvr.Cells["SoLuongTon"].Value);
            }

            DataRow row = dsChenhLech.Tables["ChenhLechKiemKe"].NewRow();
            row["TenThuoc"] = cboTenThuocKK.Text.Trim();
            row["MaThuoc"] = txtMaThuocKK.Text.Trim();
            row["ChenhLech"] = Convert.ToInt32(txtChenhLech.Text.Trim());
            row["SoLuong"] = SoLuongThuc;
            row["SoLuongTon"] = txtSoLuongTonKK.Text.Trim();
            dsChenhLech.Tables["ChenhLechKiemKe"].Rows.Add(row);

            int chenhlech = Convert.ToInt32(txtChenhLech.Text);

            if (chenhlech > 0)
            {
                MessageBox.Show(cboTenThuocKK.Text + " dư " + txtChenhLech.Text);

            }
            else if (chenhlech < 0)
            {
                MessageBox.Show(cboTenThuocKK.Text + " thiếu  " + txtChenhLech.Text);
            }
            else
            {
                MessageBox.Show(cboTenThuocKK.Text + " chênh lệch " + txtChenhLech.Text, "Thông báo");

            }



        }

        private void btn_XemHDNgay_Click(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            DataTable dataTable = data.getDatatable("Select * from HoaDon,CHITIETHD,Thuoc where HoaDon.MaHD=ChiTietHD.MaHD and ChiTietHD.MaThuoc=Thuoc.MaThuoc and NgayLap='" + DateTime.Now + "' and MaNV='" + MaNV + "'");
            DanhSachHoaDon dsHD = new DanhSachHoaDon();
            dsHD.SetDataSource(dataTable);
            dsHD.SetDatabaseLogon("sa", "123");
            frm_Report_KiemKe report = new frm_Report_KiemKe();
            report.crystalReportViewer1.ReportSource = dsHD;
        }

        private void btn_XemHDThang_Click(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            DataTable dataTable = data.getDatatable("Select * from HoaDon,CHITIETHD,Thuoc where HoaDon.MaHD=CHITIETHD.MaHD and CHITIETHD.MaThuoc=Thuoc.MaThuoc and MaNV='" + MaNV + "'");
            DanhSachHoaDon dsHD = new DanhSachHoaDon();
            dsHD.SetDataSource(dataTable);
            dsHD.SetDatabaseLogon("sa", "123");
            frm_Report_KiemKe report = new frm_Report_KiemKe();
            report.crystalReportViewer1.ReportSource = dsHD;
            report.ShowDialog();
        }

        private void btn_SoPNNgay_Click(object sender, EventArgs e)
        {
            DataSet ds = new DataSet();
            DataTable dataTable = data.getDatatable("Select * from PHIEUNHAP,CHITIETPHIEUNHAP,THUOC where PHIEUNHAP.MaPN=CHITIETPHIEUNHAP.MaPN and CHITIETPHIEUNHAP.MaThuoc=THUOC.MaThuoc and NgayNhap='" + DateTime.Now + "' and MaNV='" + MaNV + "'");
            DanhSachPhieuNhap dsPN = new DanhSachPhieuNhap();
            dsPN.SetDataSource(dataTable);
            dsPN.SetDatabaseLogon("sa", "123");
            frm_Report_KiemKe report = new frm_Report_KiemKe();
            report.crystalReportViewer1.ReportSource = dsPN;
            report.ShowDialog();
        }

        private void tabControl1_SelectedIndexChanged(object sender, EventArgs e)
        {
            //MessageBox.Show(tabControl1.SelectedIndex.ToString());
        }

        private void txtMaThuocKK_TextChanged(object sender, EventArgs e)
        {
            DataTable dt = dsChenhLech.Tables["ChenhLechKiemKe"];
            foreach (DataRow row in dt.Rows)
            {
                if (txtMaThuocKK.Text == row["MaThuoc"].ToString())
                {
                    txtChenhLech.Text = row["ChenhLech"].ToString();
                }
            }
        }
        //load nha cung cấp cho phiếu nhập
        public void loadPhieuNhap()
        {
            int k = (int)data.getScalar("Select count(*) from PhieuNhap where NgayNhap ='" + DateTime.Today + "'");
            k = k + 1;
            //string today = DateTime.Today.ToString("ddMMyyyy");
            string MaPN = "PN" + /*today +*/ k.ToString("000");
            txt_NH_MaPN.Text = MaPN;
            Load_NCC();
        }

        private void cboTenThuocKK_SelectedIndexChanged_1(object sender, EventArgs e)
        {
            txtChenhLech.Clear();
            string maThuoc = cboTenThuocKK.SelectedValue.ToString();
            load_dgvLoThuoc_KiemKe(maThuoc);
        }



        public void Load_NCC()
        {
            DataTable dt = new DataTable();
            dt = data.getDatatable("Select * from NhaCungCap");
            cmb_NH_NCC.DataSource = dt;
            cmb_NH_NCC.DisplayMember = "TenNNC";
            cmb_NH_NCC.ValueMember = "MaNCC";
        }
        // KHOA
        public void LoadBaoCao()
        {
            int soHD = (int)data.getScalar("Select count(*) from HoaDon where NgayLap='" + DateTime.Now + "' and MaNV='" + MaNV + "'");
            lbl_BC_SoHD.Text = soHD.ToString() + " Hóa đơn";
            soHD = (int)data.getScalar("Select count(*) from HoaDon where MaNV='" + MaNV + "'");
            lbl_BC_SoHDThang.Text = soHD.ToString() + " Hóa đơn";
            int soPN = (int)data.getScalar("Select count(*) from PhieuNhap where NgayNhap='" + DateTime.Now + "' and MaNV='" + MaNV + "'");
            lbl_BC_SoPhieuNhapNgay.Text = soPN.ToString() + " Phiếu nhập";
            soPN = (int)data.getScalar("Select count(*) from PhieuNhap where MaNV='" + MaNV + "'");
            lbl_BC_SoPhieuNhapThang.Text = soPN.ToString() + " Phiếu nhập";
        }
    }
}
