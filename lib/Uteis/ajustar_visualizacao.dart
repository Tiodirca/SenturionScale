
class AjustarVisualizacao {
  // //metodo para ajustar a largura com base no tamanho da tela
  // static ajustarLarguraComponentes(double larguraTela,String telaListagem) {
  //   double largura= larguraTela;
  //   //verificando qual o tamanho da tela
  //   //600 corresponde a telas para mobile
  //   if (larguraTela <= 600) {
  //     largura = larguraTela * 0.95;
  //   }else if (telaListagem == Constantes.telaListagemItens) {
  //     largura = larguraTela;
  //   }else {
  //     largura = larguraTela * 0.6;
  //   }
  //   return largura;
  // }

//metodo para ajustar o tamanho do textField com base no tamanho da tela
  static ajustarTextField(double larguraTela) {
    double tamanho = 150;
    //verificando qual o tamanho da tela
    if (larguraTela <= 600) {
      tamanho = 190;
    } else {
      tamanho = 500;
    }
    return tamanho;
  }
}
