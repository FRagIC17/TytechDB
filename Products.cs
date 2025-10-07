using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tytech_Application
{
    public class Products
    {
        public int product_id { get; set; }
        public string product_name { get; set; } = " ";
        public string product_description { get; set; } = " ";
        public double product_price { get; set; }
        public string product_image_url { get; set; } = " ";
        public string product_published { get; set; } = " ";
        public string product_active { get; set; } = " ";
        public string category_name { get; set; } = " ";
        public string supplier_name { get; set; } = " ";
        public int inventory_quantity { get; set; }

    }
}
