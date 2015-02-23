# Tailing Logs

- https://news.ycombinator.com/item?id=9089871
- http://www.vanheusden.com/multitail/

```bash
# Tail multiple logs on different hosts
tail -f <(ssh -t host 'tail -f /var/log/sth') <(ssh -t host2 'tail -f /var/log/sth')
```
