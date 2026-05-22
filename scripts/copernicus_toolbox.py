import copernicusmarine

# login to Copernicus Marine Service --------------------------------------

# fill with your username and password
copernicusmarine.login(
  username = "username",
  password = "password"
)

# static variables --------------------------------------------------------

# list of datasets ids (check Copernicus Data Store)
datasets = ["datasetid1","datasetid2","datasetid3"]

# list of variables to download per dataset (check var names in product page)
variables = [["var1"],["var2"],["var3","var4"]]

# spatial extension to download in the format: xmin,xmax,ymin,ymax
extension = [-180,180,-90,90]

# temporal extension to download
st_date = "yyyy-mm-ddT00:00:00"
en_date = "yyyy-mm-ddT00:00:00"

# depth extension to download (if applicable)
mindepth = 0
maxdepth = 1000

# specify the folder where you want to save your files
out_dir = "where/to/save/"

# specify how to name the downloaded files
filenames = ["filename1.nc","filename2.nc","filename3.nc"]

# download ----------------------------------------------------------------

for i in range(len(datasets)):
  copernicusmarine.subset(
    dataset_id = datasets[i],
    variables = variables[i],
    minimum_longitude = extension[0],
    maximum_longitude = extension[1],
    minimum_latitude = extension[2],
    maximum_latitude = extension[3],
    start_datetime = st_date,
    end_datetime = en_date,
    minimum_depth = mindepth,
    maximum_depth = maxdepth,
    output_directory = out_dir,
    output_filename = filenames[i],
    force_download = True
  )
