m_dir="g:\*.*"
lcFile = SYS(2000,m_dir)
DO WHILE NOT EMPTY(m.lcFile)
    ADIR(laFile, m.lcFile)
    INSERT INTO FileList FROM ARRAY laFile
    lcFile = SYS(2000,m_dir,1)
ENDDO