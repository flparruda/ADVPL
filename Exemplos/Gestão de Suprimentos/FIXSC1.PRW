#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#include "Protheus.ch"

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矲IXSC1矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Ajusta registros da SC1,                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/
User Function FIXSC1()

	Local oProcess//inclu韉o o par鈓etro lEnd para controlar o cancelamento da janela
	Local nOpc := 0 
	
	nOpc := Aviso('Aten玢o', 'Essa rotina tem como objetivo efetuar o ajuste da SC1 (solicita玢o de compra), corrigindo o vinculo com a SC7 (pedido de compras) e a quantidade entregue da Solicita玢o de Compras (C1_QUJE).', {'Processar','Imprimir', 'Cancelar' }, 2)
	If nOpc <> 3   
		oProcess := MsNewProcess():New({|lEnd| FixProc(@oProcess, @lEnd, nOpc) },"Atualizando Dados da SC1 - Solicita玢o de compras","Lendo Registros do Pedido de Vendas",.T.) 
		oProcess:Activate()
	Endif

Return    
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矲ixProc矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Ajusta registros da SC1,                                   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/
Function FixProc(oProcess, lEnd, nOpc)
	Local cQuery 	:= ""
	Local cUpDate   := ""
	Private cAliasSC1	:= ""
	Private nTotal	:= 0
	//nCountC5 := SC5->(RecCount())
	ConOut("Inicio do Ajuste - SC1")
	
	cAliasSC1 := GetNextAlias()
	oProcess:SetRegua1(2) 
	oProcess:IncRegua1("Lendo Solici玢o de compras:")             
	
	cQuery := "	SELECT C1_FILIAL,C1_NUM,C7_NUMSC,C1_COTACAO,C1_PEDIDO, C1_FORNECE, C1_LOJA,C7_FORNECE,C7_LOJA, C1_QUJE, C1_QUANT,C7_QUANT,C7_NUM,C7_ITEM,C1_ITEM,C7_ITEMSC "
	cQuery += "		FROM "+RetSqlName("SC1")+" SC1 "
	cQuery += "			LEFT JOIN " +RetSqlName("SC7")+ " SC7 "
	cQuery += "			ON SC7.C7_NUMSC <> '' "
	cQuery += "			AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += "		WHERE "
	cQuery += "		  	  SC1.C1_NUM = SC7.C7_NUMSC "
	cQuery += "		  AND SC1.C1_FILIAL = '"+xFilial("SC1")+"'"
	cQuery += "		  AND SC1.C1_QUJE = 0 "
	cQuery += "		  AND SC1.C1_RESIDUO <> 'S' "
	cQuery += "		  AND SC1.C1_COTACAO = SC7.C7_NUMCOT "
	cQuery += "		  AND SC1.D_E_L_E_T_ = ' ' "
	cQuery += "	ORDER BY SC1.C1_NUM "
	cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasSC1),.F.,.T.)
		    //Conta quantos registros existem, e seta no tamanho da r間ua
		    Count To nTotal
		oProcess:IncRegua1("Ser鉶 processados: "+ alltrim(str(nTotal))+ " registros")
		oProcess:SetRegua2(nTotal)
	DbSelectArea(cAliasSC1)
	(cAliasSC1)->(DbGoTop())	
	
	If nOpc = 2  	
		Imprel()
	Else
		ProcUPD(oProcess)
	EndIf
			
Return Nil
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矷mpRel矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Rela玢o de registros que ser鉶 modificados                 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/
static Function ImpRel()
Local oReport

oReport:= ReportDef()
oReport:PrintDialog()

Return
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矷mpRel矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprime o Relatorio Release 4                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/
Static Function ReportDef()

	Local oReport
	Local oSection
	Local oCell         
	
	oReport:= TReport():New("FIXSC1","Fix de solicita玢o de Compras",, {|oReport| ReportPrint(oReport)},OemToAnsi(" Este relatorio imprime uma rela玢o dos ajustes que s鉶 efetuados na SC1 (Solicita玢o de compras)"))
	
	
	oSection := TRSection():New(oReport,OemToAnsi("SC11"),{"SC1"},/*{Array com as ordens do relat髍io}*/,/*Campos do SX3*/,/*Campos do SIX*/) 
	
	oSection:SetHeaderPage()
	
	TRCell():New(oSection,"C1_FILIAL", "SC1")
	TRCell():New(oSection,"C1_NUM", "SC1")
	TRCell():New(oSection,"C7_NUMSC", "SC7")
	TRCell():New(oSection,"C1_COTACAO", "SC1")
	TRCell():New(oSection,"C1_PEDIDO", "SC1")
	TRCell():New(oSection,"C1_FORNECE", "SC1")
	TRCell():New(oSection,"C1_LOJA", "SC1")
	TRCell():New(oSection,"C7_FORNECE", "SC7")
	TRCell():New(oSection,"C7_LOJA", "SC7")
	TRCell():New(oSection,"C1_QUJE", "SC1")
	TRCell():New(oSection,"C1_QUANT", "SC1")
	TRCell():New(oSection,"C7_QUANT", "SC7")
	TRCell():New(oSection,"C7_NUM", "SC7")
	TRCell():New(oSection,"C7_ITEM", "SC7")
	TRCell():New(oSection,"C1_ITEM", "SC1")
	TRCell():New(oSection,"C7_ITEMSC", "SC7")

Return(oReport)
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矷mpRel矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprime o Relatorio Release 4                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/
Static Function ReportPrint(oReport)

	Local oSection  := oReport:Section(1)
	Local cGrupCom  := ""
	Local cAliasSAJ := "SAJ"
	
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矲iltragem do relat髍io                                                  �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SAJ")
	dbSetOrder(1)
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砊ransforma parametros Range em expressao SQL                            �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	MakeSqlExpr(oReport:uParam)
	
	oReport:Section(1):BeginQuery()	
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矼etodo EndQuery ( Classe TRSection )                                    �
	//砅repara o relat髍io para executar o Embedded SQL.                       �
	//矱xpA1 : Array com os parametros do tipo Range                           �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
	oReport:SetMeter(SAJ->(LastRec()))
	oSection:Init()
	
	While  !(cAliasSC1)->(Eof())
		
		oSection:Cell("C1_FILIAL"):SetValue((cAliasSC1)->C1_FILIAL)
		oSection:Cell("C1_NUM"):SetValue((cAliasSC1)->C1_NUM)
		oSection:Cell("C7_NUMSC"):SetValue((cAliasSC1)->C7_NUMSC)
		oSection:Cell("C1_COTACAO"):SetValue((cAliasSC1)->C1_COTACAO)
		oSection:Cell("C1_PEDIDO"):SetValue((cAliasSC1)->C1_PEDIDO)
		oSection:Cell("C1_FORNECE"):SetValue((cAliasSC1)->C1_FORNECE)
		oSection:Cell("C1_LOJA"):SetValue((cAliasSC1)->C1_LOJA)
		oSection:Cell("C7_FORNECE"):SetValue((cAliasSC1)->C7_FORNECE)
		oSection:Cell("C7_LOJA"):SetValue((cAliasSC1)->C7_LOJA)
		oSection:Cell("C1_QUJE"):SetValue((cAliasSC1)->C1_QUJE)
		oSection:Cell("C1_QUANT"):SetValue((cAliasSC1)->C1_QUANT)
		oSection:Cell("C7_QUANT"):SetValue((cAliasSC1)->C7_QUANT)
		oSection:Cell("C7_NUM"):SetValue((cAliasSC1)->C7_NUM)
		oSection:Cell("C7_ITEM"):SetValue((cAliasSC1)->C7_ITEM)
		oSection:Cell("C1_ITEM"):SetValue((cAliasSC1)->C1_ITEM)
		oSection:Cell("C7_ITEMSC"):SetValue((cAliasSC1)->C7_ITEMSC)
	
	  	oSection:PrintLine()	
		oReport:IncMeter()
	   	(cAliasSC1)->(dbSkip())
	
	EndDo
	
	(cAliasSC1)->(DbCloseArea())
	oSection:Finish()

Return NIL

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un玢o    矷mpRel矨utor 矻eandro Nishihata		    矰ata  �06/08/2019潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Imprime o Relatorio Release 4                              潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
/*/

Static function ProcUPD(oProcess) 	
Local count := 0
	While !(cAliasSC1)->(Eof())
	
		cUpDate := " UPDATE "+RetSqlName("SC1")
		cUpDate += " 	SET C1_QUJE = C1_QUANT, "
		cUpDate += " 		C1_FORNECE = '"+(cAliasSC1)->C7_FORNECE+"', "
		cUpDate += " 		C1_LOJA = '"+(cAliasSC1)->C7_LOJA+"', "
		cUpDate += " 		C1_PEDIDO = '"+(cAliasSC1)->C7_NUM+"', "
		cUpDate += " 		C1_ITEMPED = '"+(cAliasSC1)->C7_ITEM+"' "
		cUpDate += " 	WHERE C1_FILIAL = '"+xFilial("SC1")+"' "
		cUpDate += " 	  AND C1_NUM = '"+(cAliasSC1)->C1_NUM+"' "
		cUpDate += "	  AND C1_ITEM = '"+(cAliasSC1)->C1_ITEM+"' "
		cUpDate += " 	  AND C1_QUJE = 0 "
		cUpDate += " 	  AND D_E_L_E_T_ = ' ' "
	
		TcSqlExec(cUpDate)
		
		ConOut("Solicitacao Ajustada: "+(cAliasSC1)->C1_NUM )
		count ++ 
		oProcess:IncRegua2("Processando registro: "+ alltrim(str(count))+"/"+alltrim(str(nTotal)) )
		
		(cAliasSC1)->(dbSkip())
	EndDo
	
		msginfo("T閞mino do Ajuste - SC1")
		ConOut("T閞mino do Ajuste - SC1")
	
	Return NIL
	