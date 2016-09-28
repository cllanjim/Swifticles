<?php
    $con = mysql_connect("unionbeer.db.6143131.hostedresource.com", "unionbeer", "Union1234!");
    
    if($con)
    {
        mysql_select_db('unionbeer');
    
        $firstName = $_GET['fn'];
        $lastName = $_GET['ln'];
        $email = $_GET['em'];
        $phone_number = $_GET['pn'];
        
    if(strlen($email) > 0 || strlen($phone_number) > 0)
    {
        $result = mysql_query("select id from customer where email = '$email' or phone = '$phone_number'");
        $id = -1;
        while($row = mysql_fetch_array($result)){$id = $row['id'];}
        if($id==-1)
        {
            mysql_query("insert into customer (created, firstName, lastName, email, phone) VALUES (NOW(), '$firstName', '$lastName', '$email', '$phone_number')");
            $result = mysql_query("select id from customer where email = '$email' or phone = '$phone_number'");
            $id = -1;
            while($row = mysql_fetch_array($result)){$id = $row['id'];}
        }
        else
        {
            mysql_query("update customer set email = '$email' where id='$id'");
            mysql_query("update customer set firstName = '$firstName' where id='$id'");
            mysql_query("update customer set lastName = '$lastName' where id='$id'");
            mysql_query("update customer set phone = '$phone_number' where id='$id'");
        }
        
        $results[] = array('id' => $id);
        echo json_encode($results);
        
    }
    else
    {
        $results[] = array('id' => -1);
        echo json_encode($results);
        
    }
    mysql_close($con);
}
?>
