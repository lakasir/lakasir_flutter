import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'menu': 'Menu',
          'menu_transaction': 'Transaction',
          'menu_transaction_subtitle': 'Manage your transaction',
          'menu_product': 'Product',
          'menu_product_subtitle': 'Manage your product',
          'menu_member': 'Member',
          'menu_member_subtitle': 'Member is a success key for your bussiness',
          'menu_profile': 'Profile',
          'menu_profile_subtitle': 'Every person is has an iconic profile',
          'menu_about': 'About',
          'menu_about_subtitle': 'Every bussiness is has an iconic purpose',
          'menu_setting': 'Setting',
          'menu_setting_subtitle': 'Lakasir is configurable',
          'setting': 'Setting',
          'setting_general': 'General',
          'setting_category': 'Category',
          'setting_currency': 'Currency',
          'setting_system': 'System',
          'setting_language': 'Language',
          'setting_language_success': 'Language has been changed',
          'setting_dark_mode': 'Dark Mode',
          'global_cancel': 'Cancel',
          'global_delete': 'Delete',
          'global_deleted_item': '@item has been deleted',
          'global_save': 'Save',
          'global_submit': 'Submit',
          'transaction_cashier': 'Cashier',
          'transaction_history': 'Transaction History',
          'transaction_list': 'Transaction List',
          'transaction_analytics': 'Transaction Analytics',
          'transaction_analytics_filter_today': 'Today',
          'transaction_analytics_filter_yesterday': 'Yesterday',
          'transaction_analytics_filter_this_week': 'This Week',
          'transaction_analytics_filter_last_week': 'Last Week',
          'transaction_analytics_filter_this_month': 'This Month',
          'transaction_analytics_filter_last_month': 'Last Month',
          'transaction_analytics_filter_this_year': 'This Year',
          'transaction_analytics_filter_last_year': 'Last Year',
          'transaction_analytics_gross_profit': 'Gross Profit',
          'transaction_analytics_net_profit': 'Net Profit',
          'transaction_analytics_total_sales': 'Total Sales',
          'global_from': 'From',
          'transaction_detail': 'Transaction Detail',
          'field_code': 'Code',
          'field_date': 'Date',
          'field_friend_price': 'Friend Price',
          'field_total_quantity': 'Total Quantity',
          'field_total_price': 'Total Price',
          'field_subtotal': 'Total sub price @price',
          'cashier_set_cash_drawer': 'Set Cash Drawer',
          'cashier_set_cash_drawer_info': 'You can\'t use cashier before you set cash drawer',
          'cashier_set_cash_drawer_enabled_info': 'You can\'t use cash drawer before you enabled cash drawer in setting, do you want to enable it now?',
          'cashier_cash_drawer_current': 'Current Cash Drawer: @cash',
          'cashier_cash_drawer': 'Cash Drawer',
          'cashier_cash_drawer_close': 'Close!',
          'cashier_cash_drawer_closed': 'Cash Drawer Closed',
          'cashier_cash_drawer_question_activate': 'If you activate this, you will be asked to enter the amount of money in the cash drawer before you can use the cashier',
          'cashier_cash_drawer_question_deactivate': 'If you deactivate this, your cashier will be aboe to use without enter the amount of money in the cash drawer',
          'cashier_search_trigger': 'Type min 3 character to trigger search',
          'cashier_add_to_cart': 'Add to cart',
          'cashier_success_message': 'Selling success',
          'global_no_item': 'No @item',
          'field_qty': 'Qty',
          'cart_list': 'Cart List',
          'cart_list_proceed': 'Proceed to payment',
          'cart_delete_all': 'Delete All Cart',
          'cart_delete_all_content': 'Are you sure to delete all cart?',
          'cart_pay_it': 'Pay it',
          'cart_edit_detail': 'Edit Detail',
          'field_tax': 'Tax',
          'field_member': 'Member',
          'field_payment_method': 'Payment Method',
          'field_select_item': 'Select @item',
          'global_save_title': 'Save @title',
          'global_sure?': 'Are you sure?',
          'global_sure_ok': 'Ok',
          'global_sure_content': 'Are you sure to delete this @item?',
          'global_total': 'Total',
          'field_payed_money': 'Payed Money',
          'field_change': 'Change',
          'global_yes': 'Yes',
          'global_ok': 'Ok',
          'global_no': 'No',
          'global_warning': 'Warning!',
          'product_add': 'Add Product',
          'product_edit': 'Edit Product',
          'global_detail': 'Detail',
          'global_filter': 'Filter',
          'global_filter_item': 'Filter @item',
          'global_search': 'Search',
          'field_product_name': 'Product Name',
          'field_name': 'Name',
          'field_sku': 'SKU',
          'field_barcode': 'Barcode',
          'field_is_non_stock': 'Product Without Stock',
          'field_stock': 'Stock',
          'field_stock_info': 'If you enable this, stock will be used as product without stock',
          'field_initial_price': 'Initial Price',
          'field_selling_price': 'Selling Price',
          'field_category': 'Category',
          'field_select_category': 'Select Category',
          'field_type': 'Type',
          'field_unit': 'Unit',
          'global_camera': 'Camera',
          'global_gallery': 'Gallery',
          'global_select_image_source': 'Select Image Source',
          'option_product': 'Product',
          'option_service': 'Service',
          'validation_required': 'This @field is required',
          'product_add_success': 'Product has been added',
          'global_added_item': '@item has been added',
          'global_updated_item': '@item has been updated',
          'global_add_item': 'Add @item',
          'global_edit_item': 'Edit @item',
          'global_delete_item': 'Delete @item',
          'field_email_or_phone': 'Email or Phone',
          'field_email': 'Email',
          'field_phone': 'Phone',
          'field_address': 'Address',
          'info_leave_empty':
              'You can leave this field empty and will be generated automatically',
          'field_role_user': 'Role User',
          'field_language': 'Language',
          "logout": "Logout",
          'field_business_type': 'Business Type',
          'field_option_retail_business_type': 'Retail',
          'field_option_wholesale_business_type': 'Wholesale',
          'field_option_fnb_business_type': 'F&B',
          'field_option_fashion_business_type': 'Fashion',
          'field_option_pharmacy_business_type': 'Pharmacy',
          'field_owner_name': 'Owner\'s Name',
          'field_location': 'Location',
          'field_currency': 'Currency',
          'field_shop_name': 'Shop Name',
          'field_category_name': 'Category Name',
          'setup_title': 'Access to your',
          'setup_your_registered_domain': 'Your registered domain',
          'setup': 'Setup',
          'setup_doesnt_have_domain': 'Are you the owner, and you don’t have the Domain yet?',
          'setup_please_create': 'Please create!',
          'setup_domain_error': 'Domain not found',
          'setup_please_enter_your_domain': 'Please enter your domain',
          'please_agree': 'Please agree to our terms and conditions',
          'agreement_sentence': 'By creating the shop, you agree to our Terms and Conditions',
          'please_fill_form': 'Please fill the form correctly',
          'info_domain': 'Your domain will be your shop name, for example: yourshopname.lakasir.com',
          'sign_up': 'Sign Up',
          'sign_in': 'Sign In',
          'field_domain_name': 'Domain Name',
          'field_password': 'Password',
          'field_password_confirmation': 'Password Confirmation',
          'field_remember_me': 'Remember Me',
          'forgot_password': 'Forgot Password?',
          'register_success': 'Register Success, check your email to get more information of your shop',
          'create_your_shop': 'Create your shop',
        },
        'id_ID': {
          'menu': 'Menu',
          'menu_transaction': 'Transaksi',
          'menu_transaction_subtitle': 'Atur transaksi anda',
          'menu_product': 'Produk',
          'menu_product_subtitle': 'Atur produk anda',
          'menu_member': 'Member',
          'menu_member_subtitle': 'Member adalah kunci kesuksesan bisnis anda',
          'menu_profile': 'Profil',
          'menu_profile_subtitle': 'Setiap orang memiliki profil yang ikonik',
          'menu_about': 'Tentang',
          'menu_about_subtitle': 'Setiap bisnis memiliki tujuan yang ikonik',
          'menu_setting': 'Pengaturan',
          'menu_setting_subtitle': 'Lakasir mudah dikonfigurasi',
          'setting': 'Pengaturan',
          'setting_general': 'Umum',
          'setting_category': 'Kategori',
          'setting_currency': 'Mata Uang',
          'setting_system': 'Sistem',
          'setting_language': 'Bahasa',
          'setting_language_success': 'Bahasa telah diubah',
          'setting_dark_mode': 'Mode Gelap',
          'global_cancel': 'Batal',
          'global_delete': 'Hapus',
          'global_deleted_item': '@item berhasil dihapus',
          'global_save': 'Simpan',
          'global_submit': 'Submit',
          'transaction_cashier': 'Kasir',
          'transaction_history': 'Riwayat Transaksi',
          'transaction_list': 'Dafar Transaksi',
          'transaction_analytics': 'Analitik Transaksi',
          'transaction_analytics_filter_today': 'Hari Ini',
          'transaction_analytics_filter_yesterday': 'Kemarin',
          'transaction_analytics_filter_this_week': 'Minggu Ini',
          'transaction_analytics_filter_last_week': 'Minggu Lalu',
          'transaction_analytics_filter_this_month': 'Bulan Ini',
          'transaction_analytics_filter_last_month': 'Bulan Lalu',
          'transaction_analytics_filter_this_year': 'Tahun Ini',
          'transaction_analytics_filter_last_year': 'Tahun Lalu',
          'transaction_analytics_gross_profit': 'Keuntungan Kotor',
          'transaction_analytics_net_profit': 'Keuntungan Bersih',
          'transaction_analytics_total_sales': 'Total Penjualan',
          'global_from': 'Dari',
          'transaction_detail': 'Detail Transaksi',
          'field_code': 'Kode',
          'field_date': 'Tanggal',
          'field_friend_price': 'Harga Teman',
          'field_total_quantity': 'Total Kuantitas',
          'field_total_price': 'Total Harga',
          'field_subtotal': 'Total sub price @price',
          'cashier_set_cash_drawer': 'Atur Uang Laci',
          'cashier_set_cash_drawer_info': 'Anda tidak dapat menggunakan kasir sebelum anda mengatur uang laci',
          'cashier_set_cash_drawer_enabled_info': 'Anda tidak dapat menggunakan uang laci sebelum anda mengaktifkan uang laci di pengaturan, apakah anda ingin mengaktifkannya sekarang?',
          'cashier_cash_drawer_current': 'Uang Laci Sekarang: @cash',
          'cashier_cash_drawer': 'Uang Laci',
          'cashier_cash_drawer_close': 'Tutup!',
          'cashier_cash_drawer_closed': 'Uang Laci Ditutup',
          'cashier_cash_drawer_question_activate': 'Jika anda mengaktifkan ini, anda akan diminta untuk memasukkan jumlah uang di laci sebelum anda dapat menggunakan kasir',
          'cashier_cash_drawer_question_deactivate': 'Jika anda menonaktifkan ini, kasir anda akan dapat digunakan tanpa memasukkan jumlah uang di laci',
          'cashier_search_trigger': 'Ketik minimal 3 karakter untuk mencari',
          'cashier_add_to_cart': 'Tambahkan ke keranjang',
          'cashier_success_message': 'Penjualan berhasil',
          'global_no_item': 'Tidak ada @item',
          'field_qty': 'Jumlah',
          'cart_list': 'Daftar Keranjang',
          'cart_list_proceed': 'Lanjutkan ke pembayaran',
          'cart_delete_all': 'Hapus Semua Keranjang',
          'cart_delete_all_content':
              'Apakah anda yakin ingin menghapus semua keranjang?',
          'cart_pay_it': 'Bayar',
          'cart_edit_detail': 'Edit Detail',
          'field_tax': 'Tax',
          'field_member': 'Member',
          'field_payment_method': 'Metode Pembayaran',
          'field_select_item': 'Pilih @item',
          'global_save_title': 'Simpan @title',
          'global_sure?': 'Anda yakin?',
          'global_sure_ok': 'Ok',
          'global_sure_content': 'Anda yakin ingin menghapus @item ini?',
          'global_total': 'Total',
          'field_payed_money': 'Uang dibayar',
          'field_change': 'Kembalian',
          'global_yes': 'Ya',
          'global_ok': 'Ok',
          'global_no': 'Tidak',
          'global_warning': 'Peringatan!',
          'product_add': 'Tambah Produk',
          'product_edit': 'Edit Produk',
          'global_detail': 'Detail',
          'global_filter': 'Filter',
          'global_filter_item': 'Filter @item',
          'global_search': 'Cari',
          'field_product_name': 'Nama Produk',
          'field_name': 'Nama',
          'field_sku': 'SKU',
          'field_barcode': 'Barcode',
          'field_is_non_stock': 'Produk Tanpa Stok',
          'field_stock': 'Stok',
          'field_stock_info': 'Jika anda mengaktifkan ini, stok akan digunakan sebagai produk tanpa stok',
          'field_initial_price': 'Harga Awal',
          'field_selling_price': 'Harga Jual',
          'field_category': 'Kategori',
          'field_select_category': 'Pilih Kategori',
          'field_type': 'Tipe',
          'field_unit': 'Satuan',
          'global_camera': 'Kamera',
          'global_gallery': 'Galeri',
          'global_select_image_source': 'Pilih Sumber Gambar',
          'option_product': 'Produk',
          'option_service': 'Jasa',
          'validation_required': '@field ini wajib diisi',
          'product_add_success': 'Produk berhasil ditambahkan',
          'global_added_item': '@item berhasil ditambahkan',
          'global_updated_item': '@item berhasil diubah',
          'global_add_item': 'Tambah @item',
          'global_edit_item': 'Edit @item',
          'global_delete_item': 'Haous @item',
          'field_email_or_phone': 'Email atau Nomor Telepon',
          'field_email': 'Email',
          'field_phone': 'Nomor Telepon',
          'field_address': 'Alamat',
          'info_leave_empty':
              'Kamu bisa mengosongkan field ini dan akan digenerate secara otomatis',
          'field_role_user': 'Jabatan Pengguna',
          'field_language': 'Bahasa',
          "logout": "Keluar",
          'field_business_type': 'Tipe Bisnis',
          'field_option_retail_business_type': 'Pengecer/Klontong',
          'field_option_wholesale_business_type': 'Grosir',
          'field_option_fnb_business_type': 'Kafe dan Restoran',
          'field_option_fashion_business_type': 'Distro dan Fashion',
          'field_option_pharmacy_business_type': 'Farmasi',
          'field_owner_name': 'Nama Pemilik',
          'field_location': 'Lokasi',
          'field_currency': 'Mata Uang',
          'field_shop_name': 'Nama Toko',
          'field_category_name': 'Nama Kategori',
          'setup_title': 'Masuk ke',
          'setup_your_registered_domain': 'Domainmu yang terdaftar',
          'setup': 'Setup',
          'setup_doesnt_have_domain': 'Anda pemilik, dan anda belum memiliki domain?',
          'setup_please_create': 'Buat sekarang!',
          'setup_domain_error': 'Domain tidak ditemukan',
          'setup_please_enter_your_domain': 'Silahkan masukkan domain anda',
          'please_agree': 'Mohon setujui syarat dan ketentuan kami',
          'agreement_sentence': 'Dengan membuat toko, anda setuju dengan Syarat dan Ketentuan kami',
          'please_fill_form': 'Isi form dengan benar',
          'info_domain': 'Domain anda akan menjadi nama toko anda, contoh: nama-toko.lakasir.com',
          'sign_up': 'Dafar',
          'sign_in': 'Masuk',
          'field_domain_name': 'Nama Domain',
          'field_password': 'Kata Sandi',
          'field_password_confirmation': 'Konfirmasi Kata Sandi',
          'field_remember_me': 'Ingat Saya',
          'forgot_password': 'Lupa Kata Sandi?',
          'register_success': 'Pendaftaran berhasil, cek email anda untuk mendapatkan informasi lebih lanjut tentang toko anda',
          'create_your_shop': 'Buata toko anda',
        },
      };
}