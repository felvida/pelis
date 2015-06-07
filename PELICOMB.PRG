PARAM V_i,V_m     && NUMERO y tope para combinaciones    Cn,m =c5,2
private v_ocupa   && se debe crear una en cada llamada
combi[v_i]=v_i    && se llama desde pelimete.prg
store 0 to v_ocupa
@ 1,64 say "pelicomb.prg"+str(v_i,2)
do while  combi[v_i] <= v_n   && FOR combi[v_i]=v_i TO V_n  
 if v_i>1   && no puede ser en un solo iif 
   vale =  combi[v_i] > combi[v_i-1]
 else       && ^se ejecuta esto y da error runtime
   vale =  combi[v_i] >= v_i
 endif
 IF vale  && VALE ESTA COMBINACION DE NUMEROS
    If   v_i>=V_m  && hemos procesado ya el tope  2
     v_suma=0
     v_fra=''
     for v_j=1 to v_m && imprimo resultado  hasta 2
      v_fra=v_fra+str( combi[v_j],2)+':'
      sele kkpeli  && linea por linea del dir
      go combi[v_j]
      v_suma=v_suma+   OCUPA
     endfor
     sele salida
     appe blank
     repla NOMBRE with w( v_fra) ,ocupa with w(v_suma)
     @ 19,36 say v_fra+"-"+ str(v_suma)+","+str(recno()) && debug
     v_min=iif(ocupa<v_min,ocupa,v_min)
    Else
     V_OCUPA=V_OCUPA+combi[v_i]
     DO pelicomb WITH v_i+1,V_m && RECURSIVO
    Endif
 ENDIF
combi[v_i]= combi[v_i]+1
if m_kk=13  && como de intro que se salga de aqui
 return
endif
m_kk=inkey()
if m_kk=13
 return
endif
Enddo
return
* llamadas 1, [1],c(2), [1,2] print [1,3] 
*          1, [1,3], print [1,4]
*          1,[1,5] return
*          1, [2],c(2) [2,2]
*          
