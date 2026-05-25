@echo off
echo Setting up Fooocus-inswapper for RTX 50-series GPU...

python -m venv venv
call venv\Scripts\activate

pip install --upgrade pip
pip install "typing-extensions==4.12.2"
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
pip install -r requirements_versions.txt
pip install gradio==3.41.2 jinja2==3.1.2 starlette==0.27.0 fastapi==0.103.2 uvicorn==0.23.2 anyio==3.7.1 httpx==0.24.1 pydantic==1.10.13
pip install basicsr==1.4.2 facexlib==0.2.5 realesrgan

echo Patching basicsr...
powershell -Command "(gc venv\Lib\site-packages\basicsr\data\degradations.py) -replace 'from torchvision.transforms.functional_tensor import rgb_to_grayscale', 'from torchvision.transforms.functional import rgb_to_grayscale' | Set-Content venv\Lib\site-packages\basicsr\data\degradations.py"

echo Cloning CodeFormer...
if not exist "CodeFormer\CodeFormer\CodeFormerRepo" (
    cd CodeFormer\CodeFormer
    git clone https://github.com/sczhou/CodeFormer.git CodeFormerRepo
    cd ..\..
)

echo Copying vqgan_arch...
copy "CodeFormer\CodeFormer\CodeFormerRepo\basicsr\archs\vqgan_arch.py" "venv\Lib\site-packages\basicsr\archs\vqgan_arch.py"

echo Setup complete! Run run.bat to start.
pause