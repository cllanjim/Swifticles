<?php
    $con = mysql_connect("hypernova.db.6143131.hostedresource.com", "hypernova", "Hyp3r#N0va");
    if($con)
    {
        mysql_select_db('hypernova');
        $result = mysql_query("select thumb_q.scene_id as scene_id, thumb_q.thumb_url as thumb_url, images.imageURL as image_url from (((select scene.id as scene_id, scene.image_id as large_id, images.imageURL as thumb_url FROM scene inner join images on scene.thumb_id = images.id) as thumb_q) inner join images on thumb_q.large_id = images.id);");
        
        $results = array();
        
        while($row = mysql_fetch_array($result))
        {
            $results[] = array('id' => $row['scene_id'],
                               'thumb_url' => $row['thumb_url'],
                               'image_url' => $row['image_url']);
        }
        echo json_encode($results);
        mysql_close($con);
    }
?>
