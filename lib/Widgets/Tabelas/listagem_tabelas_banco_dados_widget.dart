import 'package:flutter/material.dart';
import 'package:senturionscale/Modelos/TabelaModelo.dart';
import 'package:senturionscale/Uteis/PaletaCores.dart';
import 'package:senturionscale/Uteis/constantes.dart';
import 'package:senturionscale/Uteis/estilo.dart';
import 'package:senturionscale/Uteis/textos.dart';

class ListagemTabelasBancoDadosWidget extends StatefulWidget {
  ListagemTabelasBancoDadosWidget({Key? key, required this.tabelas})
      : super(key: key);

  late List<TabelaModelo> tabelas;

  @override
  State<ListagemTabelasBancoDadosWidget> createState() =>
      _ListagemTabelasBancoDadosWidgetState();
}

class _ListagemTabelasBancoDadosWidgetState
    extends State<ListagemTabelasBancoDadosWidget> {
  String nomeItemDrop = "";
  String nomeTabelaSelecionada = "";
  bool exibirConfirmacaoTabelaSelecionada = false;
  Estilo estilo = Estilo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.tabelas.isEmpty) {
      nomeItemDrop = "";
    } else {
      nomeItemDrop = widget.tabelas.first.nomeTabela;
    }
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;

    return Theme(
        data: estilo.estiloGeral,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 50.0),
          width: larguraTela,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: larguraTela,
                child: Text(
                  textAlign: TextAlign.center,
                  Textos.descricaoDropDownTabelas,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              DropdownButton(
                value: nomeItemDrop,
                icon: const Icon(Icons.list_alt_outlined,size: 30),
                items: widget.tabelas
                    .map((item) => DropdownMenuItem<String>(
                          value: item.nomeTabela,
                          child: Text(
                            item.nomeTabela.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ))
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    nomeItemDrop = value!;
                    nomeTabelaSelecionada = nomeItemDrop;
                    exibirConfirmacaoTabelaSelecionada = true;
                  });
                },
              ),
              Visibility(
                visible: exibirConfirmacaoTabelaSelecionada,
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      width: larguraTela,
                      child: Column(
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                Textos.descricaoTabelaSelecionada,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                nomeTabelaSelecionada,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                height: 35,
                                width: 35,
                                child: FloatingActionButton(
                                  backgroundColor: PaletaCores.corRosaAvermelhado,
                                  onPressed: (){

                                  },
                                  child: const Icon(Icons.close_outlined,color:Colors.white),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: 150,
                            height: 70,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: PaletaCores.corVerdeCiano),
                              child: Text(
                                Textos.btnUsarTabela,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, Constantes.rotaTelaCadastro,
                                    arguments: nomeTabelaSelecionada);
                              },
                            ),
                          )
                        ],
                      )))
            ],
          ),
        ));
  }
}
