cp ja/coqlib_ja.v coqlib.v
coqc coqlib.v
cp ja/tactics_coq_ja.txt tactics_coq.txt

rm -r ja_plain
rm -r ja_parsed
rm -r ja_results

/rte_ja.sh ja/sample_ja.txt ja/semantic_templates_ja_emnlp2016.yaml
