FROM odoo:20.0

USER root

# 1) ระบบ: ฟอนต์ไทย + เครื่องมือ PDF/A (เพิ่มการ retry และจัดการ Network timeout)
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout="30" && \
    apt-get install -y --no-install-recommends \
        fonts-thai-tlwg \
        ghostscript \
        icc-profiles-free \
        qpdf && \
    fc-cache -f && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 2) ติดตั้งทับแพ็กเกจที่มาจาก apt (แก้ error cbor2 RECORD file not found)
RUN pip install --break-system-packages --no-cache-dir --ignore-installed \
        cbor2==5.6.5 \
        cryptography==44.0.3 \
        pyOpenSSL==25.0.0 \
        cffi==1.17.1

# 3) แพ็กเกจหลัก
#    pypdf ติดตั้งจาก apt มาแล้วใน image 20.0 จึงต้อง --ignore-installed --no-deps เฉพาะตัวนี้
RUN pip install --break-system-packages --no-cache-dir --ignore-installed --no-deps \
        pypdf==5.1.0 && \
    pip install --break-system-packages --no-cache-dir \
        webauthn==2.5.0 \
        pikepdf==9.5.2

USER odoo