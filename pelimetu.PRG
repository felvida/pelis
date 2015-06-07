* fic:pelimeU.prg  mete fic. de hacer un dir desde OS. ubuntu
SET DELE ON                 
set cpdia off
set safe off
sele 1
use paux alias auxi
   ? "desde:"+auxi->descdUBU
   acce "Intro" to que
   m_dir=rtrim(auxi->descdubu)
   m_hay= adir(m_buffer, m_dir ,"D")
SELE 2
v_bd="peli"
USE &v_bd    && bd.PELIS
@1,68 say"pelimetU.prg"
@1,3 say "Hay:"
@1,10 say m_hay
   do while m_hay>0
      M_NAME= m_buffer[m_hay,1]  
      IF '.'=TRIM(M_NAME) .or. '..'=TRIM(M_NAME) && '.' y '..'
      ELSE
      	m_tama= m_buffer[m_hay,2]
      	v_tip=iif( m_tama=0, 'DIR' , RIGHT(rtrim ( M_NAME),3) ) && si file=0 supongo dir
   		If  v_tip='AVI'  .or. v_tip='MPG'  .or.  v_tip='DIR'
*	      	SELE 3 && pelis
    	  	APPE BLAN
         	v_pospunto= rat('.',m_name)-1
      		repla NOMBRE with substr(M_NAME,1,v_pospunto)  && nombre
	      	REPLA OCUPA WITH m_tama                && tamano
    	  	REPLA FECHA WITH m_buffer[m_hay,3]     && fecha
      		repla DVD with auxi->numdvd            && num.dvd
	      	repla TIP with  v_tip                  && v_tip
        Endif
      ENDIF
    m_hay= m_hay-1
   enddo
go bott
RETURN
