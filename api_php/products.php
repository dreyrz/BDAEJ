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

    $formatter = new NumberFormatter('pt_BR',  NumberFormatter::CURRENCY);
    
    $action = isset( $_GET['action'] ) ? $_GET['action'] : '';
    switch( $action ) {
        case 'add':
            $product_name = isset( $_POST['product_name'] ) ? $_POST['product_name'] : '';
            $description = isset( $_POST['description'] ) ? $_POST['description'] : '';
            $value = isset( $_POST['value'] ) ? floatval( $_POST['value'] ) : 0;
            $categories = isset( $_POST['categories'] ) ? $_POST['categories'] : '';

            if ( strlen( $categories ) > 0 ) {
                $explode = explode( ',', $categories );
                $categorias = [];

                foreach( $explode as $k => $v ) {
                  $select = $database->select( 'categorias', '*', array( 'ID=?', $v ) );
                  if ( $select->num_rows == 0 ){
                    $json( [ 'status' => false, 'message' => "Categoria ($v) não encontrada." ] ); 
                  }

                  $categorias[] = $v;
                }   

               $categorias = json_encode( $categorias );

               $database->insert( 'produtos', array(
                   'nome_produto' => $product_name,
                   'descricao' => $description,
                   'categorias' => $categorias,
                   'valor' => $value
               ) );
              
               $json( [ 'status' => true ] ); 
            } else {
                $json( [ 'status' => false, 'message' => 'Insira o ID da categoria corretamente.' ] ); 
            }

            $json( [ 'status' => false ] ); 
        break;

        case 'list':
            $select = $database->select( 'produtos', '*' );
            $produtos = [];
            if ( $select->num_rows != 0 ) {
                while( $row = $select->fetch_assoc() ) {
                    $row['valor'] = $formatter->formatCurrency($row['valor'], 'BRL');
                    $produtos[] = $row;

                }
            }

            $json( [ 'status' => true, 'products' => $produtos ] ); 
        break;

        case 'delete':
            $product_id = isset( $_POST['product_id'] ) ? $_POST['product_id'] : '';
            if ( strlen( $product_id ) < 1 )
                $json( [ 'status' => false, 'message' => 'Insira o ID do produto corretamente.' ] ); 

            $select = $database->select( 'produtos', '*', array( 'ID=?', $product_id ) );
            if ( $select->num_rows != 0 ) {
                $database->_delete( 'produtos', array( 'ID=?', $product_id ) );
                $json( [ 'status' => true ] ); 
            } else {
                $json( [ 'status' => false, 'message' => 'Insira o ID do produto corretamente.' ] ); 
            }

            $json( [ 'status' => false ] ); 
        break;

        case 'edit':
            $product_id = isset( $_POST['product_id'] ) ? $_POST['product_id'] : '';
            $select = $database->select( 'produtos', '*', array( 'ID=?', $product_id ) );
            if ( $select->num_rows == 0 ){
                $json( [ 'status' => false, 'message' => 'Insira o ID do produto corretamente.' ] ); 
            }

            $product_name = isset( $_POST['product_name'] ) ? $_POST['product_name'] : '';
            $description = isset( $_POST['description'] ) ? $_POST['description'] : '';
            $value = isset( $_POST['value'] ) ? floatval( $_POST['value'] ) : 0;
            $categories = isset( $_POST['categories'] ) ? $_POST['categories'] : '';

            if ( !empty( $product_name ) )
                $database->update( 'produtos', array( 'nome_produto' => $product_name ), array( 'ID=?', $product_id ) );

            if ( !empty( $description ) )
                $database->update( 'produtos', array( 'descricao' => $description ), array( 'ID=?', $product_id ) );

            if ( !empty( $value ) )
                $database->update( 'produtos', array( 'valor' => $value ), array( 'ID=?', $product_id ) );

            if ( !empty( $categories ) ) {
                $explode = explode( ',', $categories );
                $categorias = [];

                foreach( $explode as $k => $v ) {
                    if ( $v != 'NULL' ) { 
                        $select = $database->select( 'categorias', '*', array( 'ID=?', $v ) );
                        if ( $select->num_rows == 0 ){
                            $json( [ 'status' => false, 'message' => "Categoria ($v) não encontrada." ] ); 
                        }
                        $categorias[] = $v;
                    }
                }   

               $categorias = json_encode( $categorias );
               $database->update( 'produtos', array( 'categorias' => $categorias ), array( 'ID=?', $product_id ) );
            }

            
            $json( [ 'status' => true ] ); 
        break;
    }



    //Close database connection 
    $database->close();
?>