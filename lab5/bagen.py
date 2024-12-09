from networkx.generators.random_graphs import barabasi_albert_graph

n = 1000
m0 = 10
g = barabasi_albert_graph(n,m0)

print('PROMPT Inserting ~%s edges (n=%s, m0=%s) into table E...'%(n*m0,n,m0))
print('SET FEEDBACK OFF')
print('SET TIMING OFF')
for e in g.edges:
    print('INSERT INTO E VALUES (%s, %s);'%(e[0],e[1]))
print('COMMIT;')
print('SET FEEDBACK ON')
print('SET TIMING ON')
print('PROMPT  Done.')
