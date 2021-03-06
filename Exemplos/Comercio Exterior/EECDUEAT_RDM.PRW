#INCLUDE "Protheus.ch"

/*
Programa: EECDUEAT_RDM.PRW
Objetivo: Contem as regras necess�rias para valida��o dos campos de atributos necess�rios para registro de DUE em exporta��es de caf�.
*/

/*
Fun��o  : U_DUAtList
Objetivo: Retorna a lista de valores v�lida para o atributo para gera��o do ComboBox
*/
User Function DUAtList(cCpoAtt)
Local cList := ""
Default cCpoAtt := ""

    Do Case
        Case cCpoAtt == "EE9_AT3038"//Padr�o de qualidade
            cList := "1=S: Total conformidade com os padr�es de defeito e umidade;2=XD: O caf� n�o est� em conformidade com o padr�o de defeito desejado;3=XM: O caf� n�o est� em conformidade com o padr�o de umidade desejado;4=XDM: O caf� n�o est� em conformidade com o padr�o (defeito e umidade desejados)"

        Case cCpoAtt == "EE9_AT3039"//Embarcado Em
            cList := "1=Sacas;2=Granel;99=Outros"

        Case cCpoAtt == "EE9_AT3040"//Tipo
            cList := "1=Ar�bica;2=Robusta"

        Case cCpoAtt == "EE9_AT3041"//M�todo de Processamento (1)
            cList := "1=Lavado;2=N�o Lavado"

        Case cCpoAtt == "EE9_AT3058"//M�todo de Processamento (2)
            cList := "1=Atomizado(Spray-dried);2=Liofilizado(Freeze-dried)"

        Case cCpoAtt == "EE9_AT3059"//Embalagem final
            cList := "1=Sim;2=N�o"

        Case cCpoAtt == "EE9_AT3060"//Caracter�stica Especial
            cList := "a=Especialidade / caf� gourmet;b=Associa��o 4C;c=Eurepgap;d=FLO Internacional (Fairtrade);e=Sistema Q Coffee;f=Rainforest Alliance;g=Centro das Aves Migrat�rias do Smithsonian (Bird friendly);h=Certificado UTZ;i=Padr�es Corporativos;j=Fair Trade USA;k=Outro (por favor especifique)"

    EndCase

Return cList

/*
Fun��o  : U_DUAtWhen
Objetivo: Indica se um atributo pode ser informado ou n�o, de acordo com o NCM
*/
User Function DUAtWhen(cCpoAtt)
Local lRet := .F.
Local cNCM := ""
Default cCpoAtt := ""

    If IsInCallStack("AP100MAN")//Pedido
        cNCM := AllTrim(M->EE8_POSIPI)
    ElseIf IsInCallStack("AE100MAN")//Embarque
        cNCM := AllTrim(M->EE9_POSIPI)
    EndIf

    cCpoAtt := Right(AllTrim(cCpoAtt), 4)

    Do Case
        Case cNCM == "09011110"
            lRet := (aScan( {"3038", "3039", "3040", "3041", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "09011190"
            lRet := (aScan( {"3038", "3039", "3040", "3041", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "09011200"
            lRet := (aScan( {"3038", "3039", "3040", "3041", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "09012100"
            lRet := (aScan( {"3039", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "09012200"
            lRet := (aScan( {"3039", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "21011110"
            lRet := (aScan( {"3039", "3058", "3059", "3060", "3061"} , cCpoAtt ) > 0)
        Case cNCM == "21011190"
            lRet := (aScan( {"3039", "3060", "3061"} , cCpoAtt ) > 0)
       Case cNCM == "21011200"
            lRet := (aScan( {"3039", "3060", "3061"} , cCpoAtt ) > 0)
    EndCase

    If cCpoAtt == "3061" .And. M->EE9_AT3060 <> "k"
        lRet := .F.
    EndIf

Return lRet

/*
Fun��o  : DUEEnvAt
Objetivo: Implementa��o de ponto de entrada na integra��o da DUE para definir a lista de atributos e valores informados para registro de item da DUE
*/
User Function DUEEnvAt()
Local aAttList := {}
Local aAux := {}
Local cAux := ""

    If EE9->(FieldPos("EE9_AT3038")) > 0 .And. !Empty(EE9->EE9_AT3038)//Padr�o de qualidade
        aAdd(aAttList, {"ATT_3038", EE9->EE9_AT3038})
    EndIf

    If EE9->(FieldPos("EE9_AT3039")) > 0 .And. !Empty(EE9->EE9_AT3039)///Embarcado Em
        aAdd(aAttList, {"ATT_3039", alltrim(EE9->EE9_AT3039)})
    EndIf

    If EE9->(FieldPos("EE9_AT3040")) > 0 .And. !Empty(EE9->EE9_AT3040)///Tipo
        aAdd(aAttList, {"ATT_3040", EE9->EE9_AT3040})
    EndIf

    If EE9->(FieldPos("EE9_AT3041")) > 0 .And. !Empty(EE9->EE9_AT3041)///M�todo de Processamento (Verde)
        aAdd(aAttList, {"ATT_3041", EE9->EE9_AT3041})
    EndIf

    If EE9->(FieldPos("EE9_AT3058")) > 0 .And. !Empty(EE9->EE9_AT3058)///M�todo de Processamento (Sol�vel)
        aAdd(aAttList, {"ATT_3058", EE9->EE9_AT3058})
    EndIf

    If EE9->(FieldPos("EE9_AT3059")) > 0 .And. !Empty(EE9->EE9_AT3059)///Embalagem final
        aAdd(aAttList, {"ATT_3059", if(EE9->EE9_AT3059=="1",'true','false')}) //ATT_3059 est� definido como booleano no cadastro de atributos do portal unico.
    EndIf

    If EE9->(FieldPos("EE9_AT3060")) > 0 .And. !Empty(EE9->EE9_AT3060)///Caracter�stica Especial
        aAdd(aAttList, {"ATT_3060", EE9->EE9_AT3060})
    EndIf

    If EE9->(FieldPos("EE9_AT3061")) > 0 .And. !Empty(EE9->EE9_AT3061)///Outra Caracter�stica Especial
        aAdd(aAttList, {"ATT_3061", alltrim(EE9->EE9_AT3061)})
    EndIf

Return aAttList