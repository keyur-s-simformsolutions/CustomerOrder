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
        public ActionResult AddCustomer()
        {
            return View();
        }
        [HttpPost]
        public ActionResult AddCustomer(Customer customer)
        {
            _context.Database.ExecuteSqlCommand("exec InsertCustomer @FirstName,@Lastname,@CustomerCity ,@WorkingArea,@Grade,@OpeningAmount,@ReceivingAmount,@PaymentAmount,@OutstandingAmount,@Phone",

                new SqlParameter("@FirstName", customer.FirstName),
                new SqlParameter("@LastName", customer.LastName),
                new SqlParameter("@CustomerCity", customer.CustomerCountry),
                new SqlParameter("@WorkingArea", customer.WorkingArea),
                new SqlParameter("@Grade", customer.Grade),
                new SqlParameter("@OpeningAmount", customer.OpeningAmount),
                new SqlParameter("@ReceivingAmount", customer.ReceivingAmount),
                new SqlParameter("@PaymentAmount", customer.PaymentAmount),
                new SqlParameter("@OutstandingAmount", customer.OutstandingAmount),
                new SqlParameter("@Phone", customer.PhoneNo));
            return RedirectToAction("Index");
        }
        public ActionResult AddAgent()
        {
            return View();
        }
        [HttpPost]
        public ActionResult AddAgent(Agent agent)
        {
            _context.Database.ExecuteSqlCommand("exec InsertAgent @AgentName, @WorkingArea,@Commission,@PhoneNo,@Country",
                new SqlParameter("@AgentName", agent.AgentName),
                new SqlParameter("@WorkingArea", agent.WorkingArea),
                new SqlParameter("@Commission", agent.Commission),
                new SqlParameter("@PhoneNo", agent.PhoneNo),
                new SqlParameter("@Country", agent.Country));



                
            return View();
        }

    }
}