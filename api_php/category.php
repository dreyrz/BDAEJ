<?php 
    include 'mysql/mysql.php';
    include 'mysql/config.php';

    $json = function( $arr ) {
		header( 'Content-Type: application/json' );
		die( json_encode( $arr, JSON_PRETTY_PRINT ) );
	};

    //Database instance
    $database = Db::i( 'internal', $info['sql_site']['sql_host'],
    $info['sql_site']['sql_user'],
    $info['sql_site']['sql_pass'],
    $info['sql_site']['sql_database'],
    $info['sql_site']['sql_tbl_prefix'],
    $info['sql_site']['sql_port'] );
        
    //Start database connection					
    $database->establishConnection();
    
    $action = isset( $_GET['action'] ) ? $_GET['action'] : '';
    switch( $action ) {
        case 'add':
            $category_name = isset( $_POST['category_name'] ) ? $_POST['category_name'] : '';
            if ( strlen( $category_name ) < 2 )
                $json( [ 'status' => false, 'message' => 'Insira a categoria corretamente.' ] ); 

            $database->insert( 'categorias', array( 'categoria_nome' => $category_name ) );
            $json( [ 'status' => true ] ); 
        break;

        case 'list':
            $select = $database->select( 'categorias', '*' );
            $categorias = [];
            if ( $select->num_rows != 0 ) {
                while( $row = $select->fetch_assoc() )
                    $categorias[] = $row;
            }

            $json( [ 'status' => true, 'categories' => $categorias ] ); 
        break;

        case 'edit':
            $category_id = isset( $_POST['category_id'] ) ? $_POST['category_id'] : '';
            $category_name = isset( $_POST['category_name'] ) ? $_POST['category_name'] : '';

            if ( strlen( $category_id ) < 1 )
                $json( [ 'status' => false, 'message' => 'Insira o ID da categoria corretamente.' ] ); 

             if ( strlen( $category_name ) < 2 )
                $json( [ 'status' => false, 'message' => 'Insira o nome da categoria corretamente.' ] ); 


            $select = $database->select( 'categorias', '*', array( 'ID=?', $category_id ) );
            if ( $select->num_rows != 0 ) {
                $database->update( 'categorias', array( 'categoria_nome' => $category_name ), array( 'ID=?', $category_id ) );
                $json( [ 'status' => true ] ); 
            } else {
                $json( [ 'status' => false, 'message' => 'Insira o ID da categoria corretamente.' ] ); 
            }
            
            $json( [ 'status' => false ] ); 
        break;

        case 'delete':
            $category_id = isset( $_POST['category_id'] ) ? $_POST['category_id'] : '';
            if ( strlen( $category_id ) < 1 )
                $json( [ 'status' => false, 'message' => 'Insira o ID da categoria corretamente.' ] ); 

            $select = $database->select( 'categorias', '*', array( 'ID=?', $category_id ) );
            if ( $select->num_rows != 0 ) {
                $database->_delete( 'categorias', array( 'ID=?', $category_id ) );
                $json( [ 'status' => true ] ); 
            } else {
                $json( [ 'status' => false, 'message' => 'Insira o ID da categoria corretamente.' ] ); 
            }

            $json( [ 'status' => false ] ); 
        break;
    }



    //Close database connection 
    $database->close();
?>
