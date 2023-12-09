<?php
$servername = "localhost";
$database = "";
$username = "";
$password = "";

$conn = mysqli_connect($servername, $username, $password, $database);

if (!$conn) {
    die("Falha na conexão" . mysqli_connect_error());
}else{
    $acao = $_POST['acao'];
    $tabela = $_POST['tabela'];
    
    if($acao == "criarTabela" && $tabela){
        $sql = "CREATE TABLE $tabela (
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            primeiraHoraPulpito VARCHAR(255) NOT NULL,
            segundaHoraPulpito VARCHAR(255) NOT NULL,
            primeiraHoraEntrada VARCHAR(255) NOT NULL,
            segundaHoraEntrada VARCHAR(255) NOT NULL,
            recolherOferta VARCHAR(255) NOT NULL,
            uniforme VARCHAR(255) NOT NULL,
            mesaApoio VARCHAR(255) NOT NULL,
            servirSantaCeia VARCHAR(255) NOT NULL,
            dataCulto VARCHAR(255) NOT NULL,
            horarioTroca VARCHAR(255) NOT NULL,
            irmaoReserva VARCHAR(255) NOT NULL)";
             if (mysqli_query($conn, $sql)) {
                echo "sucesso";
            } else {
                echo "erro";
            }
    }else if($acao == "exibirTabelas"){
        $sql = "SHOW TABLES";
        $result = mysqli_query($conn,$sql); 
        $listaFinal = [];
        while($table = mysqli_fetch_assoc($result))
        {   
            $retorno = json_encode($table);
            array_push($listaFinal,$retorno);
        }
        for ($interacao=0; $interacao <count($listaFinal); $interacao++){
            echo $listaFinal[$interacao]. ",";
        }
    }else if($acao == "deletarTabela" && $tabela){
        $sql = "DROP TABLE $tabela";
        if (mysqli_query($conn, $sql)) {
            echo "sucesso";
        } else {
            echo "erro";
        }
}else if($acao == "adicionarDados" &&$tabela){
    $primeiraHoraPulpito = $_POST['primeiraHoraPulpito'];
    $segundaHoraPulpito = $_POST['segundaHoraPulpito'];
    $primeiraHoraEntrada = $_POST['primeiraHoraEntrada'];
    $segundaHoraEntrada = $_POST['segundaHoraEntrada'];
    $recolherOferta = $_POST['recolherOferta'];
    $uniforme = $_POST['uniforme'];
    $mesaApoio = $_POST['mesaApoio'];
    $servirSantaCeia = $_POST['servirSantaCeia'];
    $dataCulto = $_POST['dataCulto'];
    $horarioTroca = $_POST['horarioTroca'];
    $irmaoReserva = $_POST['irmaoReserva'];

    $sql = "INSERT INTO $tabela (primeiraHoraPulpito,segundaHoraPulpito,primeiraHoraEntrada,
    segundaHoraEntrada,recolherOferta,uniforme,mesaApoio,servirSantaCeia,
    dataCulto,horarioTroca,irmaoReserva) VALUES ('$primeiraHoraPulpito','$segundaHoraPulpito',
    '$primeiraHoraEntrada','$segundaHoraEntrada','$recolherOferta',
    '$uniforme','$mesaApoio','$servirSantaCeia','$dataCulto','$horarioTroca','$irmaoReserva')";
        if (mysqli_query($conn, $sql)) {
            echo "sucesso";
        } else {
            echo "erro";
        }
}else if($acao == "atualizarDados" &&$tabela){
    $primeiraHoraPulpito = $_POST['primeiraHoraPulpito'];
    $segundaHoraPulpito = $_POST['segundaHoraPulpito'];
    $primeiraHoraEntrada = $_POST['primeiraHoraEntrada'];
    $segundaHoraEntrada = $_POST['segundaHoraEntrada'];
    $recolherOferta = $_POST['recolherOferta'];
    $uniforme = $_POST['uniforme'];
    $mesaApoio = $_POST['mesaApoio'];
    $servirSantaCeia = $_POST['servirSantaCeia'];
    $dataCulto = $_POST['dataCulto'];
    $horarioTroca = $_POST['horarioTroca'];
    $irmaoReserva = $_POST['irmaoReserva'];
    $id = $_POST['id'];

    $sql = "UPDATE $tabela SET primeiraHoraPulpito='$primeiraHoraPulpito',segundaHoraPulpito='$segundaHoraPulpito',
    primeiraHoraEntrada='$primeiraHoraEntrada',segundaHoraEntrada='$segundaHoraEntrada',recolherOferta='$recolherOferta',
    uniforme='$recolherOferta',mesaApoio='$mesaApoio',servirSantaCeia='$servirSantaCeia',dataCulto='$dataCulto',horarioTroca='$horarioTroca',irmaoReserva='$irmaoReserva' WHERE id=$id";
        if (mysqli_query($conn, $sql)) {
            echo "sucesso";
        } else {
            echo "erro";
        }
}else if($acao == "recuperarDados" && $tabela){
    $sql = "SELECT * FROM $tabela";
    $result = mysqli_query($conn,$sql); 
    $listaFinal = [];
    while($table = mysqli_fetch_assoc($result))
    {   
        $retorno = json_encode($table,JSON_UNESCAPED_UNICODE);
    echo$retorno. " || ";
    }
    for ($interacao=0; $interacao <count($listaFinal); $interacao++){
        echo $listaFinal[$interacao]. ",";
    }
}else if($acao == "recuperarDadosPorID" && $tabela){
    $id = $_POST['id'];
    $sql = "SELECT * FROM $tabela WHERE id = $id";
    $result = mysqli_query($conn,$sql); 
    $listaFinal = [];
    while($table = mysqli_fetch_assoc($result))
    {   
        $retorno = json_encode($table,JSON_UNESCAPED_UNICODE);
    echo$retorno. " || ";
    }
    for ($interacao=0; $interacao <count($listaFinal); $interacao++){
        echo $listaFinal[$interacao]. ",";
    }
}else if($acao == "deletarDados" && $tabela){
    $id = $_POST['id'];
    $sql = "DELETE FROM $tabela WHERE id =$id";
    if (mysqli_query($conn, $sql)) {
        echo "sucesso";
    } else {
        echo "erro";
    }
}
    }

mysqli_close($conn);
?>