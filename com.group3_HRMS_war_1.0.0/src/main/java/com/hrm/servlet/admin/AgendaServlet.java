package com.hrm.servlet.admin;

import com.hrm.dao.TaskDAO;
import com.hrm.model.dto.TaskDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AgendaServlet", urlPatterns = {"/agenda"})
public class AgendaServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final TaskDAO taskDAO = new TaskDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<TaskDTO> tasksToday = taskDAO.findTasksToday();
        List<TaskDTO> tasksUpcoming = taskDAO.findTasksUpcoming();

        request.setAttribute("tasksToday", tasksToday);
        request.setAttribute("tasksUpcoming", tasksUpcoming);
        request.getRequestDispatcher("/Views/Agenda.jsp").forward(request, response);
    }
}


