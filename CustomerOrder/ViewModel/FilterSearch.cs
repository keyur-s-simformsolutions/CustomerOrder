using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CustomerOrder.ViewModel
{
    public class FilterSearch
    {
        public string Search { get; set; }
        public int? SortColunm { get; set; }
        public string SortOrder { get; set; }

        [Display(Name = "City")]
        public string CityName { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        [Display(Name = "Start Date")]
        public string Sdate { get; set; }
        [DisplayFormat(DataFormatString = "{0:dd-MM-yyyy}", ApplyFormatInEditMode = true)]
        [Display(Name = "End Date")]
        public string Edate { get; set; }
        public IEnumerable<SelectListItem> Cities { get; set; }
     
    }
}