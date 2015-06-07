sele 2
use peli alias pelis
set safe off
inde on soundex(upper(nombre)) to kk
do while .t.
 clear
 sele 1
 use paux alias auxi
 @ 1,2 say " Programa para buscar filme en bd peli.dbf   pelibus.prg"
 @ 2,2 say "1 busca con var.registros=s, si no encuentras haz 2 busqueda"
 @ 3,2 say "un solo reg. mejor poner nombre separado por espacios,b"
 @ 4,3 say "(tambien busca sin espacios)Nombre peli:" 
 @ 5,2 get auxi->despro
 @ 6,4 say "continuar(s/n):" get auxi->s_n
 @ 6,34 say "varios registros(s/n):" get auxi->s_n1
 read
 if upper(auxi->s_n)='N'
  RETURN
 endif
 repla auxi->s_n2 with auxi->s_n1
 If upper(auxi->s_n1)='S' &&  varias lineas
  m_nom=rtrim(ltrim(auxi->despro))
  sele pelis
  set filter to lower(m_nom)$lower(NOMBRE)
  inde on nombre to kk1
  go top
  if eof()   && no encontro ninguno
   set filter to
   repla auxi->s_n1 with 'N'
  else       && si encontro
   count to v_hay
   brow title"hay:"+str(v_hay)
   set filter to
   loop      && preguntar otro
  endif
 Endif
  m_nom=rtrim( trim(lower(auxi->despro)))
  sele 2
  do 1busca with 1 &&
  IF found()
   edit
   brow title '^w muestra esc sigue'
   if readkey()<>12
    edit
   endif
  ELSE &&not found
    que=' '
    @ 23,1 say "Lo introduzco ahora(S/n)" get que
    read
    m_tecla=readkey()
    iF m_tecla<>12 && esc
      if upper(que)<>'N'
       appen blank
       repla nombre with auxi->despro
       edit
      endif
    eNDIF
  ENDIF && found
 repla auxi->s_n1 with auxi->s_n2
* susp
ENDDO
return && ********************************************************
proce 1busca
para llevo
   loca for m_nom$lower(NOMBRE)
   If .not. found()
     M_espa=at(' ',m_nom)
     if m_espa>0
      m_nom=substr(m_nom,1,M_espa-1)+substr(m_nom,m_espa+1)
      do 1busca with llevo+1 && loca for m_nom$lower(NOMBRE)
     endif
   Endif
return

