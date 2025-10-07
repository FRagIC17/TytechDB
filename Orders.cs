using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Tytech_Application
{
    public class Orders
    {
        public int order_id { get; set; }
        public string full_name { get; set; } = " ";
        public string supplier_name { get; set; } = " ";
        public string shipment_deliverer { get; set; } = " ";
        public string customer_address { get; set; } = " ";
        public DateTime order_date { get; set; }
        public DateTime shipment_expected_delivery { get; set; }
        public string order_status { get; set; } = " ";
    }
}
