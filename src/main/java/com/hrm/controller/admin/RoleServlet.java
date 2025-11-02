package com.hrm.controller.admin;

import com.hrm.dao.RoleDAO;
import com.hrm.model.entity.Role;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "RoleServlet", urlPatterns = {"/admin/role/*"})
public class RoleServlet extends HttpServlet {
    private final RoleDAO roleDAO = new RoleDAO();
    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || "/".equals(pathInfo)) {
                handleListRoles(request, response);
            } else if (pathInfo.matches("/\\d+")) {
                int roleId = Integer.parseInt(pathInfo.substring(1));
                handleGetRole(roleId, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || "/".equals(pathInfo)) {
                handleCreateRole(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(response, e);
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int roleId = Integer.parseInt(pathInfo.substring(1));
                handleUpdateRole(roleId, request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(response, e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            
            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                int roleId = Integer.parseInt(pathInfo.substring(1));
                handleDeleteRole(roleId, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            handleError(response, e);
        }
    }

    private void handleListRoles(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", DEFAULT_PAGE_SIZE);
        String search = request.getParameter("search");

        List<Role> roles = roleDAO.getRoles(page, pageSize, search);
        int totalItems = roleDAO.getTotalRoleCount(search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        org.json.JSONArray rolesArray = new org.json.JSONArray();
        for (Role r : roles) {
            JSONObject rj = new JSONObject();
            rj.put("roleId", r.getRoleId());
            rj.put("roleName", r.getRoleName());
            rolesArray.put(rj);
        }

        JSONObject result = new JSONObject();
        result.put("roles", rolesArray);
        result.put("currentPage", page);
        result.put("pageSize", pageSize);
        result.put("totalItems", totalItems);
        result.put("totalPages", totalPages);

        sendJsonResponse(response, result.toString());
    }

    private void handleGetRole(int roleId, HttpServletResponse response)
            throws SQLException, IOException {
        Role role = roleDAO.getRoleById(roleId);
        if (role != null) {
            sendJsonResponse(response, new JSONObject(role).toString());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleCreateRole(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        JSONObject jsonRequest = readJsonRequest(request);
        String roleName = jsonRequest.getString("roleName");

        Role role = new Role();
        role.setRoleName(roleName);

        if (roleDAO.createRole(role)) {
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJsonResponse(response, new JSONObject().put("message", "Role created successfully").toString());
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create role");
        }
    }

    private void handleUpdateRole(int roleId, HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        JSONObject jsonRequest = readJsonRequest(request);
        String roleName = jsonRequest.getString("roleName");

        Role role = new Role();
        role.setRoleId(roleId);
        role.setRoleName(roleName);

        if (roleDAO.updateRole(role)) {
            sendJsonResponse(response, new JSONObject().put("message", "Role updated successfully").toString());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Role not found or update failed");
        }
    }

    private void handleDeleteRole(int roleId, HttpServletResponse response)
            throws SQLException, IOException {
        if (roleDAO.deleteRole(roleId)) {
            sendJsonResponse(response, new JSONObject().put("message", "Role deleted successfully").toString());
        } else {
            response.sendError(HttpServletResponse.SC_CONFLICT, "Role is in use or not found");
        }
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        String value = request.getParameter(paramName);
        if (value != null && !value.isEmpty()) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                return defaultValue;
            }
        }
        return defaultValue;
    }

    private JSONObject readJsonRequest(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        String line;
        try (var reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return new JSONObject(sb.toString());
    }

    private void sendJsonResponse(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }

    private void handleError(HttpServletResponse response, Exception e) throws IOException {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(new JSONObject()
                .put("error", "Internal Server Error")
                .put("message", e.getMessage())
                .toString());
    }
}