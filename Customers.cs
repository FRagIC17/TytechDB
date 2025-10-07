using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tytech_Application
{
    public class Customers
    {
        public int customer_id { get; set; }
        public string customer_name { get; set; } = " ";
        public string customer_email { get; set; } = " ";
        public string customer_city { get; set; } = " ";
        public string customer_country { get; set; } = " ";
        public int total_orders { get; set; }
        public double total_spent { get; set; }
        public DateTime last_order_date { get; set; }
    }
}
