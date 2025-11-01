package com.hrm.controller;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailSender {

    public static void sendEmail(String to, String subject, String content) throws MessagingException {
        final String from = "hiendev2005@gmail.com";
        final String password = "dabt unzb axge jmej";

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to,false));
            msg.setSubject(subject);
            msg.setText(content);
            Transport.send(msg);
            System.out.println("Send successfully");
        } catch (Exception e) {
            System.out.println("Send Error");
            System.out.println(e);
        }
    }
}