using CustomerOrder.Context;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CustomerOrder.Controllers
{
    public class AgentsController : Controller
    {
        db_customer _context = new db_customer();

        // GET: Agents
        public ActionResult AddAgent()
        {
            return View();
        }
        [HttpPost]
        public ActionResult AddAgent(Agent agent)
        {
            _context.Database.ExecuteSqlCommand("exec InsertUpdateAgent @AgentCode, @AgentName, @WorkingArea,@Commission,@PhoneNo,@Country",
                    new SqlParameter("@AgentCode", agent.AgentCode),
                new SqlParameter("@AgentName", agent.AgentName),
                new SqlParameter("@WorkingArea", agent.WorkingArea),
                new SqlParameter("@Commission", agent.Commission),
                new SqlParameter("@PhoneNo", agent.PhoneNo),
                new SqlParameter("@Country", agent.Country));




            return RedirectToAction("AgentList");
        }
        public ActionResult AgentList()
        {
            List<Agent> AgentsList = _context.Database.SqlQuery<Agent>
         ("exec GetDataAgents").ToList<Agent>();
            return View(AgentsList);
        }
        public ActionResult Edit(int? id)
        {
            var parameters = new List<object>();

            Agent model = new Agent();


            if (id == null)
            {
                return View("Create", model);
            }
            else
            {

                model = _context.Database.SqlQuery<Agent>("exec GetById_Agent @AgentCode ", new SqlParameter("@AgentCode", id)).FirstOrDefault();
            }

            return View("AddAgent", model);
            
        }
        public ActionResult Delete(int id)
        {
            _context.Database.ExecuteSqlCommand("exec Delete_Agent @AgentCode", new SqlParameter("@AgentCode", id));
            return RedirectToAction("AgentList");

        }
    }
}