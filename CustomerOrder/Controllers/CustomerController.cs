using CustomerOrder.Context;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CustomerOrder.Controllers
{
    public class CustomerController : Controller
    {
        db_customer _context = new db_customer();
        // GET: Customer
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult AddCustomer(int id)
        {
                IEnumerable<SelectListItem> cities = _context.Cities.Select(city => new SelectListItem
            {
                Value = city.Name.ToString(),
                Text = city.Name

            });
            Customer c = new Customer()
            {
                cities = cities
            };
            c.AgentCode = id;
      
            return View(c);
        }
        [HttpPost]
        public ActionResult AddCustomer(Customer customer)
        {
            _context.Database.ExecuteSqlCommand("exec InsertUpdateCustomer @CustomerCode, @FirstName,@Lastname,@CustomerCity ,@WorkingArea,@CustomerCountry,@Grade,@OpeningAmount,@Phone,@AgentCode",
                new SqlParameter("@CustomerCode", customer.CustomerCode),
                new SqlParameter("@FirstName", customer.FirstName),
                new SqlParameter("@LastName", customer.LastName),
                new SqlParameter("@CustomerCity", customer.CustomerCity),
                new SqlParameter("@WorkingArea", customer.WorkingArea),
                new SqlParameter("@CustomerCountry", customer.CustomerCountry),
                new SqlParameter("@Grade", customer.Grade),
                new SqlParameter("@OpeningAmount", customer.OpeningAmount),
                //new SqlParameter("@ReceivingAmount", customer.ReceivingAmount),
                //new SqlParameter("@PaymentAmount", customer.PaymentAmount),
                //new SqlParameter("@OutstandingAmount", customer.OutstandingAmount),
                new SqlParameter("@Phone", customer.PhoneNo),
                new SqlParameter("@AgentCode", customer.AgentCode));
            TempData["message"] = "Added";

            return RedirectToAction("ListCustomer");
        }
      public ActionResult ListCustomer()
        {

            List<Customer> CustomerList = _context.Database.SqlQuery<Customer>
         ("exec GetData_Customer").ToList<Customer>();
            return View(CustomerList);
        }
        public ActionResult Edit(int? id)
        {
            var parameters = new List<object>();
            IEnumerable<SelectListItem> cities = _context.Cities.Select(c => new SelectListItem
            {
                Value = c.CityId.ToString(),
                Text = c.Name

            });

            Customer model = new Customer();


            if (id == null)
            {
                return View("Create", model);
            }
            else
            {

                model = _context.Database.SqlQuery<Customer>("exec GetById_Customer @CustomerCode ", new SqlParameter("@CustomerCode", id)).FirstOrDefault();
            }
            model.cities = cities;
            return View("AddCustomer", model);

        }
        public ActionResult Delete(int id)
        {
            _context.Database.ExecuteSqlCommand("exec Delete_Customer @CustomerCode", new SqlParameter("@CustomerCode", id));
            return RedirectToAction("ListCustomer");

        }
    }
}