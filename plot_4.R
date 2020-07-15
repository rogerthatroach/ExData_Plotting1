rm(list = ls())
cat("\014")

st <- Sys.time()

require(data.table)
require(ggplot2)
require(ggthemes)
require(gridExtra)
# require(sqldf)
require(rqdatatable)


df <- fread("data/household_power_consumption.txt", na.strings="?", nrows = 1)
optree <- local_td(df) %.>%
    select_rows_nse(., Date == "1/2/2007" | Date == "2/2/2007")
# cat(format(optree))
# ex_data_table(optree)

# using sql and read.csv, only benefit is it doesn't use RAM, 
# but its not faster than  simple fread
# df_sql <- read.csv2.sql("data/household_power_consumption.txt", 
#                     sql = "select * from file where Date IN ('1/2/2007', '2/2/2007')")

# using rqdatatable, its faster than reading whole data by fread as we are subsetting
# Filter Data for 2007-02-01 and 2007-02-02
df <- fread("data/household_power_consumption.txt", na.strings="?") %.>% optree

df[,dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

df1 <- df %>%
    select(Sub_metering_1, Sub_metering_2, Sub_metering_3, dateTime) %>%
    melt(id.vars = "dateTime")

plot_2 <- ggplot(df, aes(dateTime, Global_active_power)) +
    geom_line(colour = "dodgerblue3") +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    labs(y = "Global Active Power (kW)", x = "") +
    theme_light() +
    theme(text = element_text(face = "bold"))

plot_3 <- ggplot(df1, aes(dateTime, value), group = variable) +
    geom_line(aes(colour = variable)) +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
    labs(y = "Energy Sub Metering", x = "", colour = "") +
    scale_colour_tableau(palette = "Classic 10") +
    theme_light() +
    theme(text = element_text(face = "bold"),
          legend.position = "bottom", 
          legend.text=element_text(size=rel(0.5)))

a1 <- ggplot(df, aes(dateTime, Voltage)) +
    geom_line(colour = "dodgerblue3") +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
    labs(y = "Voltage", x = "datetime", colour = "") +
    theme_light() +
    theme(text = element_text(face = "bold"))

a2 <- ggplot(df, aes(dateTime, Global_reactive_power)) +
    geom_line(colour = "dodgerblue3") +
    scale_x_datetime(date_breaks = "1 day", date_labels = "%a") + 
    scale_y_continuous(breaks = scales::pretty_breaks(n = 6)) +
    labs(y = "Global_reactive_power", x = "datetime", colour = "") +
    theme_light() +
    theme(text = element_text(face = "bold"))

plot_4 <- grid.arrange(plot_2, a1, plot_3, a2)
print(plot_4)

ggsave(plot_4, filename = "codes/ExData_Plotting1/plot_4.png", width = 4, height = 4, dpi = 120)

et <- Sys.time()
print(et-st)
