using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;
using System.Diagnostics;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Tytech_Application
{
    public partial class MainWindow : Window
    {
        public string connectionString = "Server=DESKTOP-K4SQGGD;Database=TytechDB;User Id=LaugeGæstBruger;Password=DB123; TrustServerCertificate=True";

        public MainWindow()
        {
            InitializeComponent();
            LoadCategories();
            LoadSuppliers();
            ProductsDataGrid.SelectionChanged += ProductsDataGrid_SelectionChanged;

        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT category_id, category_name FROM Catalog.Categories ORDER BY category_name";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cbCategory.ItemsSource = dt.DefaultView;
                cbCategory.DisplayMemberPath = "category_name";
                cbCategory.SelectedValuePath = "category_id";
            }
        }

        private void LoadSuppliers()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT supplier_id, supplier_name FROM Catalog.Suppliers ORDER BY supplier_name";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                cbSupplier.ItemsSource = dt.DefaultView;
                cbSupplier.DisplayMemberPath = "supplier_name";
                cbSupplier.SelectedValuePath = "supplier_id";
            }
        }

        private void ProductsNavButton_Click(object sender, RoutedEventArgs e)
        {
            ProductsDataGrid.Columns.Clear();

            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Product Name", Binding = new Binding("product_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Description", Binding = new Binding("product_description") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Price", Binding = new Binding("product_price") });
            ProductsDataGrid.Columns.Add(new DataGridCheckBoxColumn { Header = "Active", Binding = new Binding("product_active") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Published", Binding = new Binding("product_published") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Catagory", Binding = new Binding("category_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Supplier", Binding = new Binding("supplier_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Inventory", Binding = new Binding("inventory_quantity") });

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                var products = connection.Query<Products>("SELECT * FROM [TytechDB].[Catalog].[ProductCatalog]").ToList();
                ProductsDataGrid.ItemsSource = products;
            }
        }

        private void CustomersNavButton_Click(object sender, RoutedEventArgs e)
        {

            ProductsDataGrid.Columns.Clear();

            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Customer Name", Binding = new Binding("customer_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Customer Email", Binding = new Binding("customer_email") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Customer City", Binding = new Binding("customer_city") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Customer Country", Binding = new Binding("customer_country") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Total Orders", Binding = new Binding("total_orders") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Total Spent", Binding = new Binding("total_spent") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Last Order Date", Binding = new Binding("last_order_date") });

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                var customers = connection.Query<Customers>(@"SELECT * FROM [TytechDB].[Sales].[CustomerOrderSummary]").ToList();
                ProductsDataGrid.ItemsSource = customers;
            }
        }

        private void OrdersNavButton_Click(object sender, RoutedEventArgs e)
        {
            ProductsDataGrid.Columns.Clear();

            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Full Name", Binding = new Binding("full_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Supplier", Binding = new Binding("supplier_name") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Shipment Delivery", Binding = new Binding("shipment_deliverer") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Customer Adresse", Binding = new Binding("customer_address") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Orders Date", Binding = new Binding("order_date") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Shipment Expected Delivery", Binding = new Binding("shipment_expected_delivery") });
            ProductsDataGrid.Columns.Add(new DataGridTextColumn { Header = "Order Status", Binding = new Binding("order_status") });


            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                var Orders = connection.Query<Orders>(@"SELECT * FROM [TytechDB].[Sales].[vDeliveryInformation]").ToList();
                ProductsDataGrid.ItemsSource = Orders;
            }
        }

        private void InsertButton_Click(object sender, RoutedEventArgs e)
        {
            if (!decimal.TryParse(ProductPriceBox.Text, out decimal Price))
            {
                MessageBox.Show("Please enter a valid price.", "Invalid Input", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (cbCategory.SelectedValue == null)
            {
                MessageBox.Show("Please select a category.", "Missing Category", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            if (cbSupplier.SelectedValue == null)
            {
                MessageBox.Show("Please select a supplier.", "Missing Supplier", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand("Catalog.pInsertNewProduct", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@product_name", ProductNameBox.Text.Trim());
                    cmd.Parameters.AddWithValue("@product_description", ProductDescriptionBox.Text.Trim());
                    cmd.Parameters.AddWithValue("@product_price", Price);
                    cmd.Parameters.AddWithValue("@product_image_url", ProductImageUrlBox.Text.Trim());
                    cmd.Parameters.AddWithValue("@product_active", ProductActiveCheckBox.IsChecked ?? false);

                    cmd.Parameters.AddWithValue("@product_published",
                        ProductPublishedPicker.SelectedDate.HasValue
                            ? ProductPublishedPicker.SelectedDate.Value
                            : (object)DBNull.Value);

                    cmd.Parameters.AddWithValue("@category_id", cbCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@supplier_id", cbSupplier.SelectedValue);

                    conn.Open();
                    var newProductId = cmd.ExecuteScalar();
                    conn.Close();

                    if (newProductId != null)
                    {
                        MessageBox.Show($"Product inserted successfully! New Product ID: {newProductId}",
                                        "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                    }
                    else
                    {
                        MessageBox.Show("No rows were inserted. Check your stored procedure.",
                                        "Warning", MessageBoxButton.OK, MessageBoxImage.Warning);
                    }
                }
            }
            catch (SqlException ex)
            {
                MessageBox.Show($"SQL Error: {ex.Message}", "Database Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}", "Unexpected Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }


        private void DeleteButton_Click(object sender, RoutedEventArgs e)
        {

            var selectedProduct = ProductsDataGrid.SelectedItem as Products;
            if (selectedProduct == null)
            {
                MessageBox.Show("Please select a product to delete.");
                return;
            }

           try
            {
                using (var connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    string sql = "EXEC Catalog.pDeleteProduct @product_id = @Id";
                    connection.Execute(sql, new { Id = selectedProduct.product_id });
                }
                MessageBox.Show("Product deleted successfully. Refresh products to see effect", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}", "Unexpected Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }

        }

        private void ProductsDataGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                if (ProductsDataGrid.SelectedItem is Products products)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.AppendLine($"Product ID: {products.product_id}");
                    sb.AppendLine($"Name: {products.product_name}");
                    sb.AppendLine($"Description: {products.product_description}");
                    sb.AppendLine($"Price: {products.product_price:C}");
                    sb.AppendLine($"Active: {products.product_active}");
                    sb.AppendLine($"Published: {products.product_published}");
                    sb.AppendLine($"Category: {products.category_name}");
                    sb.AppendLine($"Supplier: {products.supplier_name}");
                    sb.AppendLine($"Inventory Quantity: {products.inventory_quantity}");
                    SelectedRowOutput.Text = sb.ToString();
                }
            }
        }


    }
}