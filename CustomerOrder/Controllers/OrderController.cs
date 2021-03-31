using CustomerOrder.Context;
using CustomerOrder.ViewModel;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CustomerOrder.Controllers
{
    public class OrderController : Controller
    {
        db_customer _context = new db_customer();
        // GET: Order
        public ActionResult Index()
        {
            IEnumerable<SelectListItem> cities = _context.Cities.Select(c => new SelectListItem
            {
                Value = c.Name,
                Text = c.Name

            });

            FilterSearch filtermodel = new FilterSearch
            {
                Cities = cities,

            };
            return View(filtermodel);
        }
        public ActionResult AddOrder(int id)
        {

            Order order = new Order();
            order.CustomerCode = id;
            return View(order);
        }
        [HttpPost]
        public ActionResult AddOrder(Order order)
        {
            _context.Database.ExecuteSqlCommand("exec Insert_Order @OrderNum, @OrderAmount,@AdvanceAmount,@OrderDate,@CustomerCode,@OrderDescription",
         new SqlParameter("@OrderNum", order.OrderNum),
        new SqlParameter("@OrderAmount", order.OrderAmount),
        new SqlParameter("@AdvanceAmount", order.AdvanceAmount),
        new SqlParameter("@OrderDate", order.OrderDate),
        new SqlParameter("@CustomerCode", order.CustomerCode),
        new SqlParameter("@OrderDescription", order.OrderDescription));
            return RedirectToAction("Index");
        }
        public ActionResult ListOrder(string SortColumn = "", string search = "", string cityname = "", string sdate = "", string edate = "", int? cPage = 1, string SortOrder = "asc")
        {

            ViewBag.SortOrder = SortOrder;
            ViewBag.SortColumn = SortColumn;
            int pSize = 5;
            var parameters = new List<object>();
            parameters.Add(new SqlParameter("@PageSize", pSize));
            parameters.Add(new SqlParameter("@PageNumber", cPage));
            parameters.Add(new SqlParameter("@search", search));
            parameters.Add(new SqlParameter("@SortOrder", SortOrder));
            parameters.Add(new SqlParameter("@SortColumn", SortColumn));
            parameters.Add(new SqlParameter("@cityname", cityname));
            parameters.Add(new SqlParameter("@sdate", sdate));
            parameters.Add(new SqlParameter("@edate", edate));


            var outparam = new SqlParameter
            {
                ParameterName = "PossibleRows",
                DbType = System.Data.DbType.String,
                Size = Int32.MaxValue,
                Direction = System.Data.ParameterDirection.Output
            };
            parameters.Add(outparam);
            int PossibleRows = Convert.ToInt32(outparam.Value);
            if (PossibleRows >= pSize)
            {
                var TotalPages = (int)Math.Ceiling((double)((decimal)PossibleRows / pSize));
                ViewBag.TotalPages = TotalPages;
                ViewBag.CurrPage = cPage;
            }

            List<OrderViewModel> OrderList = _context.Database.SqlQuery<OrderViewModel>
        ("exec GetData_Order @search,@cityname,@sdate,@edate,@PageSize,@PageNumber,@SortOrder,@SortColumn,@PossibleRows OUTPUT", parameters.ToArray()).ToList<OrderViewModel>();

            var Totalcount = _context.Orders.Count();
            if (OrderList.Count >= pSize || cPage > 1)
            {
                var TotalPages = (int)Math.Ceiling((double)((decimal)Totalcount / pSize));
                ViewBag.TotalPages = TotalPages;
                ViewBag.CurrPage = cPage;
            }
            return PartialView(OrderList);
        }
        public ActionResult Delete(int id)
        {
            _context.Database.ExecuteSqlCommand("exec Delete_Order @OrderNum", new SqlParameter("@OrderNum", id));
            return RedirectToAction("Index");

        }
        public ActionResult OrderDetail(int id)
        {
            List<OrderViewModel> OrderList = _context.Database.SqlQuery<OrderViewModel>
   ("exec Get_AllOrder @CustomerCode", new SqlParameter("@CustomerCode", id)).ToList<OrderViewModel>();
            return View("OrderDetail", OrderList);



        }
        public ActionResult Edit(int? id)
        {


            OrderViewModel model = new OrderViewModel();


            model = _context.Database.SqlQuery<OrderViewModel>("exec GetById_Order @OrderNum ", new SqlParameter("@OrderNum", id)).FirstOrDefault();

            return View(model);

        }
    }

}