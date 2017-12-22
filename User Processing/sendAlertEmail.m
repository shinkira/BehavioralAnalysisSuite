function sendAlertEmail(guiObjects)
    % send an alert email for low performance
    setpref('Internet','SMTP_Server','smtp.gmail.com');
    setpref('Internet','E_mail','harveymice@gmail.com');
    setpref('Internet','SMTP_Username','harveymice');
    setpref('Internet','SMTP_Password','');
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');
    email_title = sprintf('%s help request',guiObjects.anName);
    email_msg = sprintf('I''m confused now... Help me!\n-%s',guiObjects.anName);
    sendmail('shinkira3@gmail.com',email_title,email_msg) ;
end