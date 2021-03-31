using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CustomerOrder.ViewModel
{
    public class OrderViewModel
    {
        public int OrderNum { get; set; }
        public int CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string CustomerCity { get; set; }
        public Nullable<decimal> OrderAmount { get; set; }
        public Nullable<decimal> AdvanceAmount { get; set; }
        public Nullable<decimal> ReceivingAmount { get; set; }
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        public Nullable<System.DateTime> OrderDate { get; set; }
        public string OrderDescription { get; set; }
        public string AgentName { get; set; }

        public int OrderPerCustomer { get; set; }

    }
}