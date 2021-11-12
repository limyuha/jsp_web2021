<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file = "sql_open.jsp" %>
<%
	int schedule_seq = Integer.parseInt(request.getParameter("schedule_seq")); 
	
	
	String sql = "select place_x, place_y, place_name FROM tour, schedule_detail where schedule_detail.schedule_seq = ? AND schedule_detail.tour_seq = tour.seq";
	pstmt = conn.prepareStatement(sql);
	pstmt.setInt(1, schedule_seq);
	rs = pstmt.executeQuery();
	
	//out.println(schedule_seq);
	
	//double[] x = new double[];
	//double[] y = new double[];
	
	
	ArrayList<Double> x = new ArrayList<>();
	ArrayList<Double> y = new ArrayList<>();
	ArrayList<String> place_name = new ArrayList<>();

	while(rs.next()) {
		double place_x = rs.getDouble("tour.place_x");
		double place_y = rs.getDouble("tour.place_y");
		String name = rs.getString("tour.place_name");
		
		x.add(place_x);
		y.add(place_y);
		place_name.add(name);
	} 
	
	String tmp = "";
	for(int i = 0; i < x.size(); i++){
		if(tmp != "") {
			tmp += "&";
		}
		tmp += x.get(i) +","+ y.get(i) +"," + place_name.get(i);
	}
	
	out.println(tmp);
	
	/*
	for(int i = 0; i < x.size(); i++){
	
		out.println(x.get(i) +"&"+ y.get(i) +"&" + place_name.get(i) + "&");
		//out.println(x.get(i) + "&");
	}
	*/
	
	/*
	String tmp = "";
	for(int i = 0; i < x.size(); i++){
		if(tmp != "") {
			tmp += "&";
		}
		tmp += x.get(i) +","+ y.get(i);
	*/
	
	pstmt.close(); conn.close();
%>