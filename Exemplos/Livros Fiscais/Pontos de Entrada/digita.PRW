#INCLUDE "RWMAKE.CH"
USER Function DIGITA()      

PRIVATE aRotina := { { "Pesquisar"  ,"AxPesqui", 0 , 1},;          
					  { "Alterar" ,"U_AAltera", 0 , 4, 2}}         

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define o cabecalho da tela de atualizacoes                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
PRIVATE cCadastro := "Complemento de Informacoes do Processo de Importacao"

PRIVATE INCLUI    := .F.
PRIVATE ALTERA    := .F.

dbSelectArea("SD1")
mBrowse( 6, 1,22,75,"SD1")


USER Function AALTERA(cAlias,nReg,nOpc)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Monta a entrada de dados do arquivo                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local aButtons := {}
Local aUsrBut  := {}
Local aAltera	:= {'D1_WDINUM','D1_WADI','D1_WADIPOS','D1_WPERII','D1_DESCR','D1_VDOLAR'}
Local aExibe	:= {'D1_DOC','D1_SERIE','D1_COD','D1_WDINUM','D1_WADI','D1_WADIPOS','D1_WPERII','D1_DESCR','D1_VDOLAR'}

Private aTELA[0][0],aGETS[0]

bCampo := {|nCPO| Field(nCPO) }
l010Auto := If(Type("l010Auto") == "U", .f.,l010Auto)

INCLUI := .F.
ALTERA := .T.

While .T.
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Envia para processamento dos Gets          �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nOpcA:=0
	
	Begin Transaction
		nOpcA := AxAltera( cAlias, nReg, 2,aExibe,aAltera)
	End Transaction
	Exit
End
dbSelectArea(cAlias)
Return

